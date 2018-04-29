################################################
## ENROLLMENT DATA
################################################
members <- c(55860, 16666, 21728, 675, 110000, 3611)
carrier <- c("Anthem BCBS", "Bright", "Cigna", "Denver Health", "Kaiser", "RMHP")
ind_enrollment_2017 <- data.frame("Carrier" = carrier, "Members" = members)
# Get total enrollment for each carrier and get ratio of members / providers
STATEWIDE_ALL <- ALL_statewide_specialty_count %>%
  group_by(Carrier) %>%
  summarise(Total = sum(count, na.rm = TRUE)) %>%
  full_join(ind_enrollment_2017, by = "Carrier") %>%
  mutate(ratio = round(Members / Total, 2), nsmall = 2)
# Plot
cols <- c("Anthem BCBS" = "blue",
          "Bright" = "deeppink3",
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(STATEWIDE_ALL, aes(x = Carrier, y = ratio, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  geom_text(aes(label= ratio, vjust = -0.5)) +
  xlab(" ") +
  ylab("Members per Provider") +
  ggtitle("Colorado Statewide Number of Members per Medical Provider") +
  scale_fill_manual(values = cols) +
  labs(caption = "  Graphic by Colorado Health Insurance Insider / @lukkyjay                                                                                                                                                           Source: SERFF") +
  theme(plot.margin = margin(5, 5, 5, 5),
        plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0),
        legend.position = "none",
        plot.caption = element_text(family = "Arial", size = 10, color = "grey", hjust = 0.5)) +
  ggsave(filename = paste0(here("/"), "Plots/statewide_ratio.png"),
         width = 12, height = 8, dpi = 1200)
