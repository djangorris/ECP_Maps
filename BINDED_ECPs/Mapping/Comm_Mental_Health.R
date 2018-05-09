# DEFINING THE MAP
col_lon <- c(-109, -102)
col_lat <- c(36.86204, 41.03)
bbox <- make_bbox(col_lon, col_lat, f=0.05)
co_map <- get_map(bbox, maptype="toner-lite", source = "stamen")
# FILTER CATEGORY
CO_ALL_ECP_BIND_COMM_MENTAL_HLTH <- filter(CO_ALL_ECP_BIND,
                                                  ECP_Category == "Community Mental Health Centers")
# DISPLAY MAP AND ADD DATA POINTS
ggmap(co_map, extent = "device") +
  # geom_density2d(data = CO_ALL_ECP_BIND_COMM_MENTAL_HLTH,
  #                aes(x = lon, y = lat),
  #                size = 0.3) +
  # stat_density2d(data = CO_ALL_ECP_BIND_COMM_MENTAL_HLTH,
  #                aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
  #                size = 0.01,
  #                bins = 10,
  #                geom = "polygon") +
  scale_fill_gradient(low = "green", high = "green4") +
  scale_alpha(range=c(0,1), limits=c(0,5)) +
  geom_point(aes(lon, lat),
             shape = 21,
             stroke = 7,
             size = 1,
             color = "green",
             fill = "green4",
             alpha = 0.5,
             data = CO_ALL_ECP_BIND_COMM_MENTAL_HLTH,
             position = position_jitter(w = 0.002, h = 0.002)) +
  facet_wrap(~Carrier, ncol = 3) +
  xlab(" ") +
  ylab(NULL) +
  ggtitle('2018 Colorado Essential Community Mental Health Centers') +
  labs(caption = "\n\n  Graphic by Colorado Health Insurance Insider | @lukkyjay                                             Source: SERFF") +
  theme_ECP_maps +
  ggsave(filename = "BINDED_ECPs/Plots/COMM_MENTAL_HLTH.png", width = 10, height = 4, dpi = 1200)
