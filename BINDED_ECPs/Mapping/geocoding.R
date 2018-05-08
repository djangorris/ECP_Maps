# < **need to research geocoding options** >
# geocodes a location (find latitude and longitude) using the Google Maps API
## USE THE GEOCODING API INFO IN SECRET.R
geo <- geocode(location = CO_all_medical_carriers$locations, output="latlon", source="google")
##############
write_csv(geo, path = "Individual_ECPs/Processed_CSV/geocoded_locations.csv")
# Bringing over the longitude and latitude data
CO_all_medical_carriers$lon <- geo$lon
CO_all_medical_carriers$lat <- geo$lat
write_csv(CO_all_medical_carriers, path = "Individual_ECPs/Processed_CSV/CO_all_medical_carriers.csv")
