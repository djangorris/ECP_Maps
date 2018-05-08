# DEFINING THE MAP
col_lon <- c(-109, -102)
col_lat <- c(36.86204, 41.03)
bbox <- make_bbox(col_lon, col_lat, f=0.05)
co_map <- get_map(bbox, maptype="toner-lite", source = "stamen")
# FILTER CATEGORY
CO_ALL_ECP_BIND_INPATIENT_HOSP <- filter(CO_ALL_ECP_BIND,
                                                  ECP_Category == "Inpatient Hospitals (other than children's hospitals)")
# DISPLAY MAP AND ADD DATA POINTS
ggmap(co_map, extent = "device") +
  geom_density2d(data = CO_ALL_ECP_BIND_INPATIENT_HOSP,
                 aes(x = lon, y = lat),
                 size = 0.3) +
  stat_density2d(data = CO_ALL_ECP_BIND_INPATIENT_HOSP,
                 aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
                 size = 0.01,
                 bins = 10,
                 geom = "polygon") +
  scale_fill_gradient(low = "red", high = "green") +
  scale_alpha(range=c(0,1), limits=c(0,5)) +
  geom_point(aes(lon, lat, color = "green"),
             shape = 21,
             size = 10,
             fill = "green",
             alpha = 0.5,
             data = CO_ALL_ECP_BIND_INPATIENT_HOSP,
             position = position_jitter(w = 0.002, h = 0.002)) +
  facet_wrap(~Carrier, ncol = 3) +
  xlab(" ") +
  ylab(NULL) +
  ggtitle("2018 Colorado Essential Community Inpatient Hospitals (other than children's hospitals)") +
  labs(caption = "\n\n  Graphic by Colorado Health Insurance Insider | @lukkyjay                                             Source: SERFF") +
  theme(plot.margin = margin(5, 5, 5, 5),
        plot.title = element_text(family = "Arial Narrow",
                                  color="grey10",
                                  size = 18,
                                  hjust=0),
        strip.text.x = element_text(size = 14,
                                    face = "bold"),
        legend.position = "none",
        plot.caption = element_text(family = "Arial",
                                    size = 12,
                                    color = "grey50",
                                    hjust = 0.5)) +
  ggsave(filename = "BINDED_ECPs/Plots/INPATIENT_HOSP.png", width = 9, height = 6, dpi = 1200)
