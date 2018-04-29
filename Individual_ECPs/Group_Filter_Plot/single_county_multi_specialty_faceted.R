### MENTAL HEALTH ###
selected_county <- "El Paso"
clean_selected_county <- str_replace_all(selected_county, " ", "_")
# Contains Psychology in specialty
STATEWIDE_ALL_Psychology <- ALL_statewide_specialty_count %>%
  filter(Specialty %in% c("103 Psychology",
                          "019 Neurology",
                          "019 Neurology, 103 Psychology",
                          'Board Certified Behavior Analyst ("BCBA")',
                          "102 Licensed Clinical Social Workers",
                          "102 Licensed Clinical Social Workers, 103 Psychology",
                          "005 Primary Care - Physician Assistant, 103 Psychology",
                          'Counseling ("ACL", "LPC")',
                          "010 Chiropracty, 103 Psychology",
                          "006 Primary Care - Nurse Practitioner, 102 Licensed Clinical Social Workers, 103 Psychology",
                          "006 Primary Care - Nurse Practitioner, 103 Psychology")) %>%
  group_by(Carrier) %>%
  summarise(Total = sum(count, na.rm = TRUE))
# Contains Psychiatry in specialty
STATEWIDE_ALL_Psychiatry <- ALL_statewide_specialty_count %>%
  filter(Specialty %in% c("029 Psychiatry",
                          "019 Neurology, 029 Psychiatry",
                          "029 Psychiatry, 103 Psychology",
                          "012 Endocrinology, 029 Psychiatry",
                          "026 Physical Medicine & Rehabilitation, 029 Psychiatry")) %>%
  group_by(Carrier) %>%
  summarise(Total = sum(count, na.rm = TRUE))
# VISUALIZING MENTAL HEALTH
data <- bind_rows("Psychology Related" = STATEWIDE_ALL_Psychology,
                  "Psychiatry Related" = STATEWIDE_ALL_Psychiatry,
                  .id = "Specialty")
data$Carrier <- as.factor(data$Carrier)
cols <- c("Anthem BCBS" = "blue",
          "Bright" = "deeppink3",
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
# Specialty categories faceted side by side
ggplot(data, aes(x = Carrier, y = Total, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~Specialty) +
  xlab(" ") +
  ylab(NULL) +
  ggtitle(str_c(selected_county, " Mental Health Providers Grouped by Similar Specialty")) +
  scale_fill_manual(values = cols) +
  labs(caption = "  Graphic by Colorado Health Insurance Insider / @lukkyjay                                                                                                                                                           Source: SERFF") +
  theme(plot.margin = margin(5, 5, 5, 5),
        plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0),
        strip.text.x = element_text(size = 12),
        legend.position = "none",
        plot.caption = element_text(family = "Arial", size = 10, color = "grey", hjust = 0.5)) +
  ggsave(filename = paste0(here("/"), "Plots/", clean_selected_county, "_multi_specialty.png"),
         width = 12, height = 8, dpi = 1200)
