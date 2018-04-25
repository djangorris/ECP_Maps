file <- "Cigna.xlsm"
path <- paste0("Indiv/", file)
ext_removed <- tools::file_path_sans_ext(file)
carrier_name <- gsub("_", " ", ext_removed, fixed=TRUE)
providers <- read_excel(path, sheet = "IndividualProviders1", skip = 2, 
                        col_names = c("NPI", "Prefix", "First_Name", "Last_Name", "Physician", "Specialty", "Street", "City", "State", "County", "Zip"), 
                        col_types = c("text", "text", "text", "skip", "text", "skip", "text", 
                                      "text", "text", "skip", "text", "text", "text", "text", "skip"))
# REMOVE "000 OTHER IF IT'S WITH ANOTHER SPECIALTY" AND ", "
providers$Specialty <- str_replace(providers$Specialty, "000 OTHER, ", "")
providers$Specialty <- str_replace(providers$Specialty, "001 General Practice, 002 Family Medicine", "002 Family Medicine")
providers$Specialty <- str_replace(providers$Specialty, "001 General Practice, ", "")
providers$Specialty <- str_replace(providers$Specialty, "002 Family Medicine, ", "")
providers$Specialty <- str_replace(providers$Specialty, "003 Internal Medicine, ", "")
providers$Specialty <- str_replace(providers$Specialty, ", 015 General Surgery", "")
providers$Specialty <- str_replace(providers$Specialty, ", 101 Pediatrics - Routine/Primary Care", "")
providers$Specialty <- str_replace(providers$Specialty, "015 General Surgery, ", "")
providers$name_location <- paste0(providers$First_Name, " ", providers$Last_Name, ": ", providers$Street, ", ", providers$City, ", ", providers$State, ", ", providers$Zip)
# REMOVE DUPLICATES
providers = providers[!duplicated(providers$name_location),]
# ADD CONCATENATED LOCATIONS COLUMN FOR GEOCODING LATER
providers$locations <- paste0(providers$Street, ", ", providers$City, ", ", providers$State, ", ", providers$Zip)
# PROVIDER SPECIALTY TO FACTOR
providers$Specialty <- as.factor(providers$Specialty)
# COUNTY TO FACTOR
providers$County <- as.factor(providers$County)
# ADD "CARRIER" COLUMN -- THIS CAN ALSO BE DONE USING .id in bind_rows()
providers$Carrier <- carrier_name
providers$Carrier <- as.factor(providers$Carrier)
# SEPARATE DENTAL PROVIDERS FROM MEDICAL PROVIDERS
CIGNA_dental_providers <- filter(providers, 
                                  Specialty %in% c("Dental - General", 
                                                   "Dental - Periodontist", 
                                                   "Dental - Orthodontist",
                                                   "Dental - Endodontist"))
CIGNA_medical_providers <- filter(providers,
                                   !Specialty %in% c("Dental - General",
                                                     "Dental - Periodontist",
                                                     "Dental - Orthodontist",
                                                     "Dental - Endodontist"))
# COUNT THE NUMBER OF PROVIDERS IN EACH CATEGORY STATEWIDE
CIGNA_statewide_specialty_count <- CIGNA_medical_providers %>% 
  group_by(Carrier, Specialty) %>% 
  summarise(count = n()) %>%
  arrange(-count)
# COUNT THE NUMBER OF PROVIDERS IN EACH CATEGORY IN EACH COUNTY
CIGNA_county_specialty_count <- CIGNA_medical_providers %>% 
  group_by(Carrier, Specialty, County) %>% 
  summarise(nproviders = n()) %>%
  arrange(-nproviders)
# ADD CONCATENATED LOCATIONS COLUMN
CIGNA_medical_providers$locations <- paste0(CIGNA_medical_providers$Street, ", ", CIGNA_medical_providers$City, ", ", CIGNA_medical_providers$State, ", ", CIGNA_medical_providers$Zip)



