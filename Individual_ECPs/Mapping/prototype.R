# < **need to research geocoding options** >
# geocodes a location (find latitude and longitude) using the Google Maps API
geo <- geocode(location = CO_all_medical_carriers$locations, output="latlon", source="google")
##############
write_csv(geo, path = "Individual_ECPs/Processed_CSV/geocoded_locations.csv")
# Bringing over the longitude and latitude data
CO_all_medical_carriers$lon <- geo$lon
CO_all_medical_carriers$lat <- geo$lat
write_csv(CO_all_medical_carriers, path = "Individual_ECPs/Processed_CSV/CO_all_medical_carriers.csv")
# DEFINING THE MAP
col_lon <- c(-109, -102)
col_lat <- c(36.86204, 41.03)
bbox <- make_bbox(col_lon, col_lat, f=0.05)
co_map <- get_map(bbox, maptype="toner-lite", source = "stamen")
# CARRIER COLORS
cols <- c("Anthem BCBS" = "blue",
          "Bright" = "deeppink3",
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Friday" = "violetred4",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
# DISPLAY MAP AND ADD DATA POINTS
ggmap(co_map) +
  geom_point(aes(lon, lat, color = Carrier), shape = 21, data = CO_all_medical_carriers, position=position_jitter(w = 0.002, h = 0.002)) +
  scale_color_manual(name = "Carrier", values = cols)
