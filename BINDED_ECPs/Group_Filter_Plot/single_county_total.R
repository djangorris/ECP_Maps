##### SINGLE COUNTY TOTAL  #####
selected_county <- "El Paso"
clean_selected_county <- str_replace_all(selected_county, " ", "_")
SINGLE_COUNTY <- ALL_county_specialty_count %>%
  filter(County == county_selected) %>%
  summarise(Total = sum(nproviders, na.rm = TRUE))
cols <- c("Anthem BCBS" = "blue",
          "Bright" = "deeppink3",
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(SINGLE_COUNTY, aes(x = Carrier, y = Total, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  xlab(" ") +
  ylab(NULL) +
  ggtitle(str_c(selected_county, " County Medical Providers")) +
  scale_fill_manual(values = cols) +
  labs(caption = "  Graphic by Colorado Health Insurance Insider / @lukkyjay                                                                                                                                                           Source: SERFF") +
  theme(plot.margin = margin(5, 5, 5, 5),
        plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0),
        legend.position = "none",
        plot.caption = element_text(family = "Arial", size = 10, color = "grey", hjust = 0.5)) +
  ggsave(filename = paste0(here("/"), "Plots/", clean_selected_county, "_total.png"),
         width = 12, height = 8, dpi = 1200)
