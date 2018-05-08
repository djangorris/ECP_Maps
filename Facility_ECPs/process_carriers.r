medical_facility_list <- list()
dental_facility_list <- list()
statewide_facility_carrier_count_list <- list()
county_facility_carrier_count_list <- list()
files <- list.files("Raw_Source_Files/Individual")
for (i in 1:length(files)) {
  filename <- files[i]
  path <- paste0("Raw_Source_Files/Individual/", filename)
  ext_removed <- tools::file_path_sans_ext(filename)
  carrier_name <- gsub("_", " ", ext_removed, fixed=TRUE)
  facility_ecps <- read_excel(path, sheet = "Facility ECPs", skip = 2,
                         col_names = c("NPI", "Name", "Facility_Type", "ECP_Category", "Street", "City", "State", "County", "Zip", "Networks"),
                         col_types = c("skip", "text", "text", "text", "skip", "text", "text", "skip", "text", "text", "text", "text", "text", "skip", "skip"))
  # ADD "CARRIER" COLUMN
  facility_ecps$Carrier <- carrier_name
  # ADD CONCATENATED NAME + LOCATION + CARRIER COLUMN TO REMOVE DUPLICATES
  facility_ecps$name_location_carrier <- paste0(facility_ecps$Name, ": ", facility_ecps$Street, ", ", facility_ecps$City, ", ", facility_ecps$State, ", ", facility_ecps$Zip, ": ", facility_ecps$Carrier)
  # REMOVE DUPLICATES
  facility_ecps = facility_ecps[!duplicated(facility_ecps$name_location_carrier),]
  # ADD CONCATENATED LOCATIONS COLUMN FOR GEOCODING LATER
  facility_ecps$locations <- paste0(facility_ecps$Street, ", ", facility_ecps$City, ", ", facility_ecps$State, ", ", facility_ecps$Zip)
  # REPLACE OTHER CATEGORY WITH FACILITY TYPE
  facility_ecps$ECP_Category <- ifelse(facility_ecps$ECP_Category %in% "Other ECP Providers", facility_ecps$Facility_Type, facility_ecps$ECP_Category)
  # SEPARATE COLLAPSED CATEGORIES INTO MULTIPLE ROWS
  facility_ecps <- separate_rows(facility_ecps, ECP_Category, sep = ",", convert = TRUE)
  # SEPARATE DENTAL ONLY facility_ecps FROM MEDICAL facility_ecps (MAY CONTAIN DENTAL AS WELL)
  dental_facility_ecps <- filter(facility_ecps, ECP_Category %in% "Dental Providers")
  medical_facility_ecps <- filter(facility_ecps, !ECP_Category %in% "Dental Providers")
  # COUNT THE NUMBER OF facility_ecps IN EACH CATEGORY STATEWIDE
  CO_facility_category_count <- medical_facility_ecps %>%
    group_by(Carrier, ECP_Category) %>%
    summarise(count = n()) %>%
    arrange(-count)
  # COUNT THE NUMBER OF facility_ecps IN EACH CATEGORY IN EACH COUNTY
  county_facility_category_count <- medical_facility_ecps %>%
    group_by(Carrier, ECP_Category, County) %>%
    summarise(n_facility_ecps = n()) %>%
    arrange(-n_facility_ecps)

  medical_facility_list[[carrier_name]] <- medical_facility_ecps
  dental_facility_list[[carrier_name]] <- dental_facility_ecps
  statewide_facility_carrier_count_list[[carrier_name]] <- CO_facility_category_count
  county_facility_carrier_count_list[[carrier_name]] <- county_facility_category_count
  }
# COMBINE ALL CARRIERS
CO_all_medical_facility_carriers <- bind_rows(medical_facility_list)
CO_all_dental_facility_carriers <- bind_rows(dental_facility_list)
CO_all_facility_carrier_count <- bind_rows(statewide_facility_carrier_count_list)
county_all_facility_carrier_count <- bind_rows(county_facility_carrier_count_list)
# Carrier TO FACTOR
CO_all_medical_facility_carriers$Carrier <- as.factor(CO_all_medical_facility_carriers$Carrier)
CO_all_dental_facility_carriers$Carrier <- as.factor(CO_all_dental_facility_carriers$Carrier)
CO_all_facility_carrier_count$Carrier <- as.factor(CO_all_facility_carrier_count$Carrier)
county_all_facility_carrier_count$Carrier <- as.factor(county_all_facility_carrier_count$Carrier)
# ECP_Category TO FACTOR
CO_all_medical_facility_carriers$ECP_Category <- as.factor(CO_all_medical_facility_carriers$ECP_Category)
CO_all_dental_facility_carriers$ECP_Category <- as.factor(CO_all_dental_facility_carriers$ECP_Category)
CO_all_facility_carrier_count$ECP_Category <- as.factor(CO_all_facility_carrier_count$ECP_Category)
county_all_facility_carrier_count$ECP_Category <- as.factor(county_all_facility_carrier_count$ECP_Category)
# COUNTY TO FACTOR
CO_all_medical_facility_carriers$County <- as.factor(CO_all_medical_facility_carriers$County)
CO_all_dental_facility_carriers$County <- as.factor(CO_all_dental_facility_carriers$County)
county_all_facility_carrier_count$County <- as.factor(county_all_facility_carrier_count$County)
### EXPORTING ###
write_csv(CO_all_medical_facility_carriers, path = "Facility_ECPs/Processed_CSV/CO_all_medical_facility_carriers.csv")
write_csv(CO_all_dental_facility_carriers, path = "Facility_ECPs/Processed_CSV/CO_all_dental_facility_carriers.csv")
write_csv(CO_all_facility_carrier_count, path = "Facility_ECPs/Processed_CSV/CO_all_facility_carrier_count.csv")
write_csv(county_all_facility_carrier_count, path = "Facility_ECPs/Processed_CSV/county_all_facility_carrier_count.csv")
