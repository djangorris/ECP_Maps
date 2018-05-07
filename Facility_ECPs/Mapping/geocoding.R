# < **need to research facility_geocoding options** >
# facility_geocodes a location (find latitude and longitude) using the Google Maps API
## USE THE facility_geoCODING API INFO IN SECRET.R
facility_geo <- geocode(location = CO_all_medical_facility_carriers$locations, output="latlon", source="google")
##############
write_csv(facility_geo, path = "Facility_ECPs/Processed_CSV/facility_geocoded_locations.csv")
# Bringing over the longitude and latitude data
CO_all_medical_facility_carriers$lon <- facility_geo$lon
CO_all_medical_facility_carriers$lat <- facility_geo$lat
write_csv(CO_all_medical_facility_carriers, path = "Facility_ECPs/Processed_CSV/CO_all_medical_facility_carriers.csv")
