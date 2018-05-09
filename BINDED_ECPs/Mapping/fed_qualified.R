# DEFINING THE MAP
col_lon <- c(-109, -102)
col_lat <- c(36.86204, 41.03)
bbox <- make_bbox(col_lon, col_lat, f=0.05)
co_map <- get_map(bbox, maptype="toner-lite", source = "stamen")
# FILTER CATEGORY
CO_ALL_ECP_BIND_FED_QUAL <- filter(CO_ALL_ECP_BIND,
                                                  ECP_Category == "Federally Qualified Health Centers")
# DISPLAY MAP AND ADD DATA POINTS
ggmap(co_map, extent = "device") +
  geom_density2d(data = CO_ALL_ECP_BIND_FED_QUAL,
                 aes(x = lon, y = lat),
                 size = 0.3) +
  stat_density2d(data = CO_ALL_ECP_BIND_FED_QUAL,
                 aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
                 size = 0.01,
                 bins = 10,
                 geom = "polygon") +
  scale_fill_gradient(low = "green", high = "green4") +
  scale_alpha(range=c(0,1), limits=c(0,5)) +
  geom_point(aes(lon, lat),
             shape = 21,
             stroke = 7,
             size = 1,
             color = "green",
             fill = "green4",
             alpha = 0.2,
             data = CO_ALL_ECP_BIND_FED_QUAL,
             position = position_jitter(w = 0.002, h = 0.002)) +
  facet_wrap(~Carrier, ncol = 4) +
  xlab(" ") +
  ylab(NULL) +
  ggtitle('2018 Colorado ECP Federally Qualified Health Centers') +
  labs(caption = "\n\n  Graphic by Colorado Health Insurance Insider | @lukkyjay                                             Source: SERFF") +
  theme_ECP_maps +
  ggsave(filename = "BINDED_ECPs/Plots/FED_QUAL.png", width = 10, height = 5, dpi = 1200)
