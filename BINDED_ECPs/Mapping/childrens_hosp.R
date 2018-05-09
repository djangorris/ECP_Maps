# DEFINING THE MAP
col_lon <- c(-106.2, -103.8)
col_lat <- c(38.5, 40.8)
bbox <- make_bbox(col_lon, col_lat, f=0.05)
denver_map <- get_map(bbox, maptype="toner-lite", source = "stamen")
# FILTER CATEGORY
CO_ALL_ECP_BIND_CHILDRENS_HOSP <- filter(CO_ALL_ECP_BIND,
                                                  ECP_Category == "Children's Hospitals (inpatient only)")
# DISPLAY MAP AND ADD DATA POINTS
ggmap(denver_map, extent = "device") +
  # geom_density2d(data = CO_ALL_ECP_BIND_CHILDRENS_HOSP,
  #                aes(x = lon, y = lat),
  #                size = 0.3) +
  stat_density2d(data = CO_ALL_ECP_BIND_CHILDRENS_HOSP,
                 aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
                 size = 0.01,
                 bins = 10,
                 geom = "polygon") +
  scale_fill_gradient(low = "green", high = "green4") +
  scale_alpha(range=c(0,1), limits=c(0,5)) +
  geom_point(aes(lon, lat),
             shape = 21,
             stroke = 12,
             size = 1,
             color = "green",
             fill = "green4",
             alpha = 0.3,
             data = CO_ALL_ECP_BIND_CHILDRENS_HOSP,
             position = position_jitter(w = 0.002, h = 0.002)) +
  facet_wrap(~Carrier, ncol = 4) +
  xlab(" ") +
  ylab(NULL) +
  ggtitle('2018 Colorado "Children\'s Hospitals (inpatient only)" Providers & Facilities') +
  labs(caption = "\n\n  Graphic by Colorado Health Insurance Insider | @lukkyjay                                             Source: SERFF") +
  theme_ECP_maps +
  ggsave(filename = "BINDED_ECPs/Plots/CHILDRENS_HOSP.png", width = 9, height = 7, dpi = 1200)
