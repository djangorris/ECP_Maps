medical_list <- list()
dental_list <- list()
statewide_carrier_count_list <- list()
county_carrier_count_list <- list()
files <- list.files("Raw_Source_Files/Individual")
for (i in 1:length(files)) {
  filename <- files[i]
  path <- paste0("Raw_Source_Files/Individual/", filename)
  ext_removed <- tools::file_path_sans_ext(filename)
  carrier_name <- gsub("_", " ", ext_removed, fixed=TRUE)
  ind_ecps <- read_excel(path, sheet = "Individual ECPs", skip = 2,
                         col_names = c("NPI", "Name", "Physician", "Specialty", "Entity_Name", "ECP_Category", "Street", "City", "State", "County", "Zip", "Networks"),
                         col_types = c("skip", "skip", "text", "skip", "skip", "skip", "text", "skip", "text", "text", "text",
                                       "text", "text", "skip", "text", "text", "text", "text", "text", "skip", "skip"))
  # ADD "CARRIER" COLUMN
  ind_ecps$Carrier <- carrier_name
  # ADD CONCATENATED NAME + LOCATION + CARRIER COLUMN TO REMOVE DUPLICATES
  ind_ecps$name_location_carrier <- paste0(ind_ecps$Name, ": ", ind_ecps$Street, ", ", ind_ecps$City, ", ", ind_ecps$State, ", ", ind_ecps$Zip, ": ", ind_ecps$Carrier)
  # REMOVE DUPLICATES
  ind_ecps = ind_ecps[!duplicated(ind_ecps$name_location_carrier),]
  # ADD CONCATENATED LOCATIONS COLUMN FOR GEOCODING LATER
  ind_ecps$locations <- paste0(ind_ecps$Street, ", ", ind_ecps$City, ", ", ind_ecps$State, ", ", ind_ecps$Zip)
  # REPLACE OTHER CATEGORY WITH SPECIALTY
  ind_ecps$ECP_Category <- ifelse(ind_ecps$ECP_Category %in% "Other ECP Providers", ind_ecps$Specialty, ind_ecps$ECP_Category)
  # SEPARATE COLLAPSED CATEGORIES INTO MULTIPLE ROWS
  ind_ecps <- separate_rows(ind_ecps, ECP_Category, sep = ",", convert = TRUE)
  # SEPARATE DENTAL ind_ecps FROM MEDICAL ind_ecps
  dental_ind_ecps <- filter(ind_ecps, ECP_Category %in% "Dental Providers")
  medical_ind_ecps <- filter(ind_ecps, !ECP_Category %in% "Dental Providers")
  # COUNT THE NUMBER OF ind_ecps IN EACH CATEGORY STATEWIDE
  CO_category_count <- medical_ind_ecps %>%
    group_by(Carrier, ECP_Category) %>%
    summarise(count = n()) %>%
    arrange(-count)
  # COUNT THE NUMBER OF ind_ecps IN EACH CATEGORY IN EACH COUNTY
  county_category_count <- medical_ind_ecps %>%
    group_by(Carrier, ECP_Category, County) %>%
    summarise(n_ind_ecps = n()) %>%
    arrange(-n_ind_ecps)

  medical_list[[carrier_name]] <- medical_ind_ecps
  dental_list[[carrier_name]] <- dental_ind_ecps
  statewide_carrier_count_list[[carrier_name]] <- CO_category_count
  county_carrier_count_list[[carrier_name]] <- county_category_count
  }
# COMBINE ALL CARRIERS
CO_all_medical_carriers <- bind_rows(medical_list)
CO_all_dental_carriers <- bind_rows(dental_list)
CO_all_carrier_count <- bind_rows(statewide_carrier_count_list)
county_all_carrier_count <- bind_rows(county_carrier_count_list)
# Carrier TO FACTOR
CO_all_medical_carriers$Carrier <- as.factor(CO_all_medical_carriers$Carrier)
CO_all_dental_carriers$Carrier <- as.factor(CO_all_dental_carriers$Carrier)
CO_all_carrier_count$Carrier <- as.factor(CO_all_carrier_count$Carrier)
county_all_carrier_count$Carrier <- as.factor(county_all_carrier_count$Carrier)
# ECP_Category TO FACTOR
CO_all_medical_carriers$ECP_Category <- as.factor(CO_all_medical_carriers$ECP_Category)
CO_all_dental_carriers$ECP_Category <- as.factor(CO_all_dental_carriers$ECP_Category)
CO_all_carrier_count$ECP_Category <- as.factor(CO_all_carrier_count$ECP_Category)
county_all_carrier_count$ECP_Category <- as.factor(county_all_carrier_count$ECP_Category)
# COUNTY TO FACTOR
CO_all_medical_carriers$County <- as.factor(CO_all_medical_carriers$County)
CO_all_dental_carriers$County <- as.factor(CO_all_dental_carriers$County)
county_all_carrier_count$County <- as.factor(county_all_carrier_count$County)
### EXPORTING ###
write_csv(CO_all_medical_carriers, path = "Individual_ECPs/Processed_CSVs/CO_all_medical_carriers.csv")
write_csv(CO_all_dental_carriers, path = "Individual_ECPs/Processed_CSVs/CO_all_dental_carriers.csv")
write_csv(CO_all_carrier_count, path = "Individual_ECPs/Processed_CSVs/CO_all_carrier_count.csv")
write_csv(county_all_carrier_count, path = "Individual_ECPs/Processed_CSVs/county_all_carrier_count.csv")
