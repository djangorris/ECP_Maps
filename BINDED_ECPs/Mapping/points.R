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
  geom_point(aes(lon, lat, color = Carrier),
             shape = 21,
             data = CO_all_medical_carriers,
             position = position_jitter(w = 0.002, h = 0.002)) +
  scale_color_manual(name = "Carrier", values = cols)
