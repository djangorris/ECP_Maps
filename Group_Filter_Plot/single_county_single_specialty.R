###### SINGLE COUNTY BY SINGLE SPECIALTY #####
selected_county <- "El Paso"
selected_specialty <- "003 Internal Medicine"
clean_selected_county <- str_replace_all(selected_county, " ", "_")
clean_selected_specialty <- str_replace_all(selected_specialty, " ", "_")
COUNTY_ALL <- ALL_county_specialty_count %>%
  group_by(Specialty, County) %>%
  filter(Specialty == selected_specialty, County == selected_county)
# plot
cols <- c("Anthem BCBS" = "blue",
          "Bright" = "deeppink3",
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(COUNTY_ALL, aes(x = Carrier, y = nproviders, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  xlab(" ") +
  ylab(NULL) +
  ggtitle(str_c("Providers listed as ", '"', selected_specialty, '" in ', selected_county, " County ")) +
  scale_fill_manual(values = cols) +
  labs(caption = "  Graphic by Colorado Health Insurance Insider / @lukkyjay                                                                                                                                                           Source: SERFF") +
  theme(plot.margin = margin(5, 5, 5, 5),
        plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0),
        legend.position = "none",
        plot.caption = element_text(family = "Arial", size = 10, color = "grey", hjust = 0.5)) +
  ggsave(filename = paste0(here("/"), "Plots/", clean_selected_county, "_", clean_selected_specialty, ".png"),
         width = 12, height = 8, dpi = 1200)
