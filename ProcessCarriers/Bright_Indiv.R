file <- "Bright.xlsm"
path <- paste0("Indiv/", file)
ext_removed <- tools::file_path_sans_ext(file)
carrier_name <- gsub("_", " ", ext_removed, fixed=TRUE)
ind_ecps <- read_excel(path, sheet = "Individual ECPs", skip = 2,
                       col_names = c("NPI", "Name", "Physician", "Specialty", "Entity_Name", "ECP_Category", "Street", "City", "State", "County", "Zip", "Networks"),
                       col_types = c("skip", "skip", "text", "skip", "skip", "skip", "text", "skip", "text", "text", "text",
                                     "text", "text", "skip", "text", "text", "text", "text", "text", "skip", "skip"))
# ADD CONCATENATED NAME + LOCATION COLUMN TO REMOVE DUPLICATES
ind_ecps$name_location <- paste0(ind_ecps$Name, ": ", ind_ecps$Street, ", ", ind_ecps$City, ", ", ind_ecps$State, ", ", ind_ecps$Zip)
# REMOVE DUPLICATES
ind_ecps = ind_ecps[!duplicated(ind_ecps$name_location),]
# ADD CONCATENATED LOCATIONS COLUMN FOR GEOCODING LATER
ind_ecps$locations <- paste0(ind_ecps$Street, ", ", ind_ecps$City, ", ", ind_ecps$State, ", ", ind_ecps$Zip)
# REPLACE OTHER CATEGORY WITH SPECIALTY
ind_ecps$ECP_Category <- ifelse(ind_ecps$ECP_Category %in% "Other ECP Providers", ind_ecps$Specialty, ind_ecps$ECP_Category)
# SEPARATE COLLAPSED CATEGORIES INTO MULTIPLE ROWS
ind_ecps <- separate_rows(ind_ecps, ECP_Category, sep = ",", convert = TRUE)
# PROVIDER ECP_Category TO FACTOR
ind_ecps$ECP_Category <- as.factor(ind_ecps$ECP_Category)
# PROVIDER SPECIALTY TO FACTOR
ind_ecps$Specialty <- as.factor(ind_ecps$Specialty)
# COUNTY TO FACTOR
ind_ecps$County <- as.factor(ind_ecps$County)
# ADD "CARRIER" COLUMN
ind_ecps$Carrier <- carrier_name
ind_ecps$Carrier <- as.factor(ind_ecps$Carrier)
# COUNT THE NUMBER OF ind_ecps IN EACH CATEGORY STATEWIDE
BRIGHT_statewide_category_count <- ind_ecps %>%
  group_by(Carrier, ECP_Category) %>%
  summarise(statewide_count = n()) %>%
  arrange(-statewide_count)
# COUNT THE NUMBER OF ind_ecps IN EACH CATEGORY IN EACH COUNTY
BRIGHT_county_category_count <- ind_ecps %>%
  group_by(Carrier, ECP_Category, County) %>%
  summarise(county_count = n()) %>%
  arrange(-county_count)
