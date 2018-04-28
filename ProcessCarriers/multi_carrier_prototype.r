install.packages("readxl")
install.packages("tidyverse")
install.packages('ggmap')
install.packages('purrr')
library(readxl)
library(tidyverse)
library(ggmap)
library(purrr)
library(knitr)
library(ggplot2)

medical_list <- list()
dental_list <- list()
statewide_carrier_count_list <- list()
# county_carrier_count_list <- list()
files <- list.files("Indiv")
for (i in 1:length(files)) {
  filename <- files[i]
  path <- paste0("Indiv/", filename)
  ext_removed <- tools::file_path_sans_ext(filename)
  carrier_name <- gsub("_", " ", ext_removed, fixed=TRUE)
  providers <- read_excel(path, sheet = "IndividualProviders1", skip = 2, 
    col_names = c("NPI", "Prefix", "First_Name", "Last_Name", "Physician", "Specialty", "Street", "City", "State", "County", "Zip"), 
    col_types = c("text", "text", "text", "skip", "text", "skip", "text", 
    "text", "text", "skip", "text", "text", "text", "text", "skip"))
  if(read_excel(sheet = "IndividualProviders2")) {
  providers2 <- read_excel(path, sheet = "IndividualProviders2", skip = 2, 
    col_names = c("NPI", "Prefix", "First_Name", "Last_Name", "Physician", "Specialty", "Street", "City", "State", "County", "Zip"), 
    col_types = c("text", "text", "text", "skip", "text", "skip", "text", 
    "text", "text", "skip", "text", "text", "text", "text", "skip"))
  # COMBINE THE TWO SHEETS
  providers_bind <- bind_rows(providers, providers2)
  # REMOVE DUPLICATES
  providers = providers_bind[!duplicated(providers_bind$NPI),]
  }
  # REMOVE "000 OTHER" AND ", "
  providers$Specialty <- str_replace(providers$Specialty, "000 OTHER, ", "")
  providers$Specialty <- str_replace(providers$Specialty, "001 General Practice, 002 Family Medicine", "002 Family Medicine")
  providers$Specialty <- str_replace(providers$Specialty, "001 General Practice, ", "")
  providers$Specialty <- str_replace(providers$Specialty, "002 Family Medicine, ", "")
  providers$Specialty <- str_replace(providers$Specialty, "003 Internal Medicine, ", "")
  providers$Specialty <- str_replace(providers$Specialty, ", 015 General Surgery", "")
  providers$Specialty <- str_replace(providers$Specialty, ", 101 Pediatrics - Routine/Primary Care", "")
  providers$Specialty <- str_replace(providers$Specialty, "015 General Surgery, ", "")
  # REPLACE "000 OTHER" WITH THEIR PROFESSIONAL NAMES
  providers$Specialty <- ifelse(providers$Prefix %in% c("AC", "DAC", "LAC"), "Acupuncture", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% c("AU", "AUD", "CHIS", "MA"), "Audiology", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% c("ACL", "LPC"), "Counseling", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% c("ANP", "NP", "FNP", "CNP"), "Nurse Practitioner", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "BCBA", "Board Certified Behavior Analyst", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% c("CFSA", "CST"), "Surgical Technologist", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "CNM", "Certified Nurse-Midwife", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% c("OD", "OPT"), "Optometry", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% c("MT", "MST"), "Massage Therapy", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% c("PA", "PAC"), "Physician Assistant", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "MD", "Doctor of Medicine", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "DO", "Doctor of Osteopathic Medicine", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% c("MFT", "LMFT"), "Marriage and Family Therapist", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "CNS", "Clinical Nurse Specialist", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "RD", "Registered Dietitian", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "CRNA", "Registered Nurse Anesthetist", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "LCSW", "102 Licensed Clinical Social Workers", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "OT", "Occupational Therapist", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "PMH", "029 Psychiatry", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% c("RN", "RNFA"), "Registered Nurse", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "CPNP", "101 Pediatrics - Routine/Primary Care", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "SLP", "Doctor of Speech-Language Pathology", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "ST", "103 Psychology", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "PHD", "PHD (No specialty listed)", providers$Specialty)
  providers$Specialty <- ifelse(providers$Prefix %in% "Not Applicable", "N/A, Non-physician", providers$Specialty)
  # providers$Specialty <- ifelse(is.na(providers$Prefix), "N/A, Non-physician", providers$Specialty)
  
  # PROVIDER SPECIALTY TO FACTOR
  providers$Specialty <- as.factor(providers$Specialty)
  # COUNTY TO FACTOR
  providers$County <- as.factor(providers$County)
  # ADD "CARRIER" COLUMN
  providers$Carrier <- carrier_name
  providers$Carrier <- as.factor(providers$Carrier)
  # SEPARATE DENTAL PROVIDERS FROM MEDICAL PROVIDERS
  dental_providers <- filter(providers, 
                             Prefix %in% c("DDS", "DMD") | 
                             Specialty %in% c("Dental - General", 
                                              "Dental - Periodontist", 
                                              "Dental - Orthodontist",
                                              "Dental - Endodontist"))
  medical_providers <- filter(providers,
                              !Prefix %in% c("DDS", "DMD"),
                              !Specialty %in% c("Dental - General",
                                                "Dental - Periodontist",
                                                "Dental - Orthodontist",
                                                "Dental - Endodontist"))
  # COUNT THE NUMBER OF PROVIDERS IN EACH CATEGORY STATEWIDE
  CO_specialty_count <- medical_providers %>% 
    group_by(Carrier, Specialty) %>% 
    summarise(count = n()) %>%
    arrange(-count)
  # COUNT THE NUMBER OF PROVIDERS IN EACH CATEGORY IN EACH COUNTY
  county_specialty_count <- medical_providers %>% 
    group_by(Carrier, Specialty, County) %>% 
    summarise(nproviders = n()) %>%
    arrange(-nproviders)
  # ADD CONCATENATED LOCATIONS COLUMN
  medical_providers$locations <- paste0(medical_providers$Street, ", ", medical_providers$City, ", ", medical_providers$State, ", ", medical_providers$Zip)
  
  medical_list[[carrier_name]] <- medical_providers
  dental_list[[carrier_name]] <- dental_providers
  statewide_carrier_count_list[[carrier_name]] <- CO_specialty_count
  # county_carrier_count_list[[carrier_name]] <- county_specialty_count
  }
# COMBINE ALL CARRIERS
CO_all_medical_carriers <- bind_rows(medical_list)
CO_all_dental_carriers <- bind_rows(dental_list)
CO_all_carrier_count <- bind_rows(statewide_carrier_count_list)
# county_all_carrier_count <- bind_rows(county_carrier_count_list)

