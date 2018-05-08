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
  geom_density2d(data = CO_ALL_ECP_BIND_CHILDRENS_HOSP,
                 aes(x = lon, y = lat),
                 size = 0.5) +
  stat_density2d(data = CO_ALL_ECP_BIND_CHILDRENS_HOSP,
                 aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
                 size = 0.01,
                 bins = 10,
                 geom = "polygon") +
  scale_fill_gradient(low = "red", high = "green", limits=c(0,9000)) +
  scale_alpha(range=c(0,1), limits=c(0,5)) +
  geom_point(aes(lon, lat, color = "green"),
             shape = 21,
             stroke = 10,
             size = 9,
             fill = "green",
             alpha = 0.5,
             data = CO_ALL_ECP_BIND_INPATIENT_HOSP,
             position = position_jitter(w = 0.002, h = 0.002)) +
  facet_wrap(~Carrier, ncol = 4) +
  xlab(" ") +
  ylab(NULL) +
  ggtitle('2018 Colorado "Children\'s Hospitals (inpatient only)" Providers & Facilities') +
  labs(caption = "\n\n  Graphic by Colorado Health Insurance Insider | @lukkyjay                                             Source: SERFF") +
  theme(plot.margin = margin(10, 10, 10, 10),
        plot.title = element_text(family = "Arial Narrow",
                                  color="grey10",
                                  size = 18,
                                  hjust=0),
        strip.text.x = element_text(size = 14,
                                    face = "bold"),
        panel.spacing.x=unit(0.2, "lines"),
        panel.spacing.y=unit(0.5, "lines"),
        legend.position = "none",
        plot.caption = element_text(family = "Arial",
                                    size = 12,
                                    color = "grey50",
                                    hjust = 0.5)) +
  ggsave(filename = "BINDED_ECPs/Plots/CHILDRENS_HOSP.png", width = 9, height = 7, dpi = 1200)
