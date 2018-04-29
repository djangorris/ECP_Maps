###### STATEWIDE BY SPECIALTY #####
selected_specialty <- "003 Internal Medicine"
clean_selected_specialty <- str_replace_all(selected_specialty, " ", "_")
STATEWIDE <- ALL_statewide_specialty_count %>%
  filter(Specialty == selected_specialty)
# plot
cols <- c("Anthem BCBS" = "blue",
          "Bright" = "deeppink3",
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(STATEWIDE, aes(x = Carrier, y = count, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  xlab(" ") +
  ylab(NULL) +
  ggtitle(str_c("Providers listed as ", '"', selected_specialty, '" in Colorado')) +
  scale_fill_manual(values = cols) +
  labs(caption = "  Graphic by Colorado Health Insurance Insider / @lukkyjay                                                                                                                                                           Source: SERFF") +
  theme(plot.margin = margin(5, 5, 5, 5),
        plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0),
        legend.position = "none",
        plot.caption = element_text(family = "Arial", size = 10, color = "grey", hjust = 0.5)) +
  ggsave(filename = paste0(here("/"), "Plots/", "statewide_", clean_selected_specialty, ".png"),
         width = 12, height = 8, dpi = 1200)
