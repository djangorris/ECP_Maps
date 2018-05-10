################################################
## ENROLLMENT DATA
################################################
C4_members <- c(37888, 14111, 21926, 877, 4557, 61689, 1426)
carrier <- c("Anthem BCBS", "Bright", "Cigna", "Denver Health", "Friday", "Kaiser", "RMHP")
ind_enrollment_2017 <- data.frame("Carrier" = carrier, "C4_members" = C4_members)
# Plot
cols <- c("Anthem BCBS" = "blue",
          "Bright" = "deeppink3",
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Friday" = "violetred4",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(ind_enrollment_2017, aes(x = Carrier, y = C4_members, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  scale_y_continuous(labels = comma) +
  geom_text(aes(label= format(C4_members, big.mark=",", trim=TRUE)), vjust = -0.5) +
  xlab(" ") +
  ylab(NULL) +
  ggtitle("2018 Connect for Health Colorado Effectuated Enrollment") +
  scale_fill_manual(values = cols) +
  labs(caption = "\n  Graphic by Colorado Health Insurance Insider | @lukkyjay                                                                                                              Source: Connect for Health Colorado",
       subtitle = "Current effectuated enrollments as of 5/7/2018\nTotals are current policies in force (not cumulative)") +
  theme_ECP_maps +
  ggsave(filename = "Individual_ECPs/Plots/C4_enrollment.png",
         width = 12, height = 8, dpi = 1200)
