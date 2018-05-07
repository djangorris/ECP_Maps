files <- list.files("Raw_Source_Files/Individual")
for (i in 1:length(files)) {
  filename <- files[i]
  path <- paste0("Raw_Source_Files/Individual/", filename)
  ext_removed <- tools::file_path_sans_ext(filename)
  carrier_name <- gsub("_", " ", ext_removed, fixed=TRUE)
  facility_ecps <- read_excel(path, sheet = "Facility ECPs", skip = 1)}


files <- list.files("Raw_Source_Files/Individual")
filename <- files[7]
path <- paste0("Raw_Source_Files/Individual/", filename)
ext_removed <- tools::file_path_sans_ext(filename)
carrier_name <- gsub("_", " ", ext_removed, fixed=TRUE)
facility_ecps <- read_excel(path, sheet = "Facility ECPs", skip = 1)
carrier_name
colnames(facility_ecps)
