file <- "Anthem_BCBS.xlsm"
path <- paste0("Indiv/", file)
ext_removed <- tools::file_path_sans_ext(file)
carrier_name <- gsub("_", " ", ext_removed, fixed=TRUE)
providers1 <- read_excel(path, sheet = "IndividualProviders1", skip = 2, 
                         col_names = c("NPI", "Prefix", "First_Name", "Last_Name", "Physician", "Specialty", "Street", "City", "State", "County", "Zip"), 
                         col_types = c("text", "text", "text", "skip", "text", "skip", "text", 
                                       "text", "text", "skip", "text", "text", "text", "text", "skip"))
providers2 <- read_excel(path, sheet = "IndividualProviders2", skip = 2,
                        col_names = c("NPI", "Prefix", "First_Name", "Last_Name", "Physician", "Specialty", "Street", "City", "State", "County", "Zip"),
                        col_types = c("text", "text", "text", "skip", "text", "skip", "text",
                                       "text", "text", "skip", "text", "text", "text", "text", "skip"))
# COMBINE THE TWO SHEETS
providers <- bind_rows(providers1, providers2)
# REMOVE "000 OTHER IF IT'S WITH ANOTHER SPECIALTY" AND ", "
providers$Specialty <- str_replace(providers$Specialty, "000 OTHER, ", "")
providers$Specialty <- str_replace(providers$Specialty, "001 General Practice, 002 Family Medicine", "002 Family Medicine")
providers$Specialty <- str_replace(providers$Specialty, "001 General Practice, ", "")
providers$Specialty <- str_replace(providers$Specialty, "002 Family Medicine, ", "")
providers$Specialty <- str_replace(providers$Specialty, "003 Internal Medicine, ", "")
providers$Specialty <- str_replace(providers$Specialty, ", 015 General Surgery", "")
providers$Specialty <- str_replace(providers$Specialty, ", 101 Pediatrics - Routine/Primary Care", "")
providers$Specialty <- str_replace(providers$Specialty, "015 General Surgery, ", "")
# REPLACE "000 OTHER" WITH THEIR PROFESSIONAL NAMES
providers$Specialty <- ifelse(providers$Prefix %in% c("AC", "DAC", "LAC"), 'Acupuncture ("AC", "DAC", "LAC")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% c("AU", "AUD", "CHIS", "MA"), 'Audiology ("AU", "AUD", "CHIS", "MA")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% c("ACL", "LPC"), 'Counseling ("ACL", "LPC")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% c("ANP", "NP", "FNP", "CNP"), 'Nurse Practitioner ("ANP", "NP", "FNP", "CNP")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "BCBA", 'Board Certified Behavior Analyst ("BCBA")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% c("CFSA", "CST"), 'Surgical Technologist ("CFSA", "CST")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "CNM", 'Certified Nurse-Midwife ("CNM")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% c("OD", "OPT"), 'Optometry ("OD", "OPT")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% c("MT", "MST"), 'Massage Therapy ("MT", "MST")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% c("PA", "PAC"), 'Physician Assistant ("PA", "PAC")', providers$Specialty)
providers$Specialty <- ifelse((providers$Prefix %in% "MD") & (providers$Specialty %in% "000 OTHER"), 
                               'Doctor of Medicine ("MD")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "DO", 'Doctor of Osteopathic Medicine ("DO")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% c("MFT", "LMFT"), 'Marriage and Family Therapist ("MFT", "LMFT")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "CNS", 'Clinical Nurse Specialist ("CNS")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "RD", 'Registered Dietitian ("RD")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "CRNA", 'Registered Nurse Anesthetist ("CRNA")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "LCSW", '102 Licensed Clinical Social Workers', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "OT", 'Occupational Therapist ("OT")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "PMH", "029 Psychiatry", providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% c("RN", "RNFA"), 'Registered Nurse ("RN", "RNFA")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "CPNP", "101 Pediatrics - Routine/Primary Care", providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "SLP", 'Doctor of Speech-Language Pathology ("SLP")', providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "ST", "103 Psychology", providers$Specialty)
# providers$Specialty <- ifelse(providers$Prefix %in% "PHD", "PHD (No specialty listed)", providers$Specialty)
providers$Specialty <- ifelse(providers$Prefix %in% "Not Applicable", "N/A, Non-physician", providers$Specialty)
# providers$Specialty <- ifelse(is.na(providers$Prefix), "N/A, Non-physician", providers$Specialty)
# ADD CONCATENATED NAME + LOCATION COLUMN TO REMOVE DUPLICATES
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
ANTHEM_dental_providers <- filter(providers, 
                           Prefix %in% c("DDS", "DMD") | 
                             Specialty %in% c("Dental - General", 
                                              "Dental - Periodontist", 
                                              "Dental - Orthodontist",
                                              "Dental - Endodontist"))
ANTHEM_medical_providers <- filter(providers,
                            !Prefix %in% c("DDS", "DMD"),
                            !Specialty %in% c("Dental - General",
                                              "Dental - Periodontist",
                                              "Dental - Orthodontist",
                                              "Dental - Endodontist"))
# COUNT THE NUMBER OF PROVIDERS IN EACH CATEGORY STATEWIDE
ANTHEM_statewide_specialty_count <- ANTHEM_medical_providers %>% 
  group_by(Carrier, Specialty) %>% 
  summarise(count = n()) %>%
  arrange(-count)
# COUNT THE NUMBER OF PROVIDERS IN EACH CATEGORY IN EACH COUNTY
ANTHEM_county_specialty_count <- ANTHEM_medical_providers %>% 
  group_by(Carrier, Specialty, County) %>% 
  summarise(nproviders = n()) %>%
  arrange(-nproviders)


