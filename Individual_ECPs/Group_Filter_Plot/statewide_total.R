### ALL MEDICAL DOCTORS STATEWIDE ###
STATEWIDE_ALL <- ALL_statewide_specialty_count %>%
  group_by(Carrier) %>%
  summarise(Total = sum(count, na.rm = TRUE))
cols <- c("Anthem BCBS" = "blue",
          "Bright" = "deeppink3",
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(STATEWIDE_ALL, aes(x = Carrier, y = Total, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  geom_text(aes(label= format(Total, big.mark=",", trim=TRUE)), vjust = -0.5) +
  xlab(" ") +
  ylab(NULL) +
  ggtitle("Colorado Statewide Medical Providers") +
  scale_fill_manual(values = cols) +
  labs(caption = "  Graphic by Colorado Health Insurance Insider / @lukkyjay                                                                                                                                                           Source: SERFF") +
  theme(plot.margin = margin(5, 5, 5, 5),
        plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0),
        legend.position = "none",
        plot.caption = element_text(family = "Arial", size = 10, color = "grey", hjust = 0.5)) +
  ggsave(filename = paste0(here("/"), "Plots/statewide_all.png"),
         width = 12, height = 8, dpi = 1200)
