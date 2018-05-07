###### STATEWIDE BY Category #####
selected_category <- "Family Planning Providers"
clean_selected_category <- str_replace_all(selected_category, " ", "_")
STATEWIDE <- CO_all_carrier_count %>%
  filter(ECP_Category == selected_category)
# plot
cols <- c("Anthem BCBS" = "blue",
          "Bright" = "deeppink3",
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Friday" = "violetred4",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(STATEWIDE, aes(x = Carrier, y = count, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  xlab(" ") +
  ylab(NULL) +
  ggtitle(str_c("Providers listed as ", '"', selected_category, '" in Colorado')) +
  scale_fill_manual(values = cols) +
  labs(caption = "  Graphic by Colorado Health Insurance Insider / @lukkyjay                                                                                                                                                           Source: SERFF") +
  theme(plot.margin = margin(5, 5, 5, 5),
        plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0),
        legend.position = "none",
        plot.caption = element_text(family = "Arial", size = 10, color = "grey", hjust = 0.5)) +
  ggsave(filename = paste0("Individual_ECPs/Plots/statewide_", clean_selected_category, ".png"),
         width = 12, height = 8, dpi = 1200)
