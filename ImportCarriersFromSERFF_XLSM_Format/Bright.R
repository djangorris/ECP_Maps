file <- "Bright.xlsm"
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
# ADD "CARRIER" COLUMN
providers$Carrier <- carrier_name
providers$Carrier <- as.factor(providers$Carrier)
# SEPARATE DENTAL PROVIDERS FROM MEDICAL PROVIDERS
BRIGHT_dental_providers <- filter(providers, 
                                    Specialty %in% c("Dental - General", 
                                                     "Dental - Periodontist", 
                                                     "Dental - Orthodontist",
                                                     "Dental - Endodontist"))
BRIGHT_medical_providers <- filter(providers,
                                   !Specialty %in% c("Dental - General",
                                                     "Dental - Periodontist",
                                                     "Dental - Orthodontist",
                                                     "Dental - Endodontist"))
# COUNT THE NUMBER OF PROVIDERS IN EACH CATEGORY STATEWIDE
BRIGHT_statewide_specialty_count <- BRIGHT_medical_providers %>% 
  group_by(Carrier, Specialty) %>% 
  summarise(count = n()) %>%
  arrange(-count)
# COUNT THE NUMBER OF PROVIDERS IN EACH CATEGORY IN EACH COUNTY
BRIGHT_county_specialty_count <- BRIGHT_medical_providers %>% 
  group_by(Carrier, Specialty, County) %>% 
  summarise(nproviders = n()) %>%
  arrange(-nproviders)
# ADD CONCATENATED LOCATIONS COLUMN
BRIGHT_medical_providers$locations <- paste0(BRIGHT_medical_providers$Street, ", ", BRIGHT_medical_providers$City, ", ", BRIGHT_medical_providers$State, ", ", BRIGHT_medical_providers$Zip)



