################################################
## ENROLLMENT DATA
################################################
members <- c(55860, 16666, 21728, 675, 110000, 3611)
carrier <- c("Anthem BCBS", "Bright", "Cigna", "Denver Health", "Kaiser", "RMHP")
ind_enrollment_2017 <- data.frame("Carrier" = carrier, "Members" = members)
# Plot
cols <- c("Anthem BCBS" = "blue",
          "Bright" = "deeppink3",
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(ind_enrollment_2017, aes(x = Carrier, y = Members, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  geom_text(aes(label= format(Members, big.mark=",", trim=TRUE)), vjust = -0.5) +
  xlab(" ") +
  ylab(NULL) +
  ggtitle("Colorado Statewide Medical Membership Enrollment") +
  scale_fill_manual(values = cols) +
  labs(caption = "  Graphic by Colorado Health Insurance Insider / @lukkyjay                                                                                                                                                           Source: SERFF") +
  theme(plot.margin = margin(5, 5, 5, 5),
        plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0),
        legend.position = "none",
        plot.caption = element_text(family = "Arial", size = 10, color = "grey", hjust = 0.5)) +
  ggsave(filename = paste0(here("/"), "Plots/statewide_enrollment.png"),
         width = 12, height = 8, dpi = 1200)
