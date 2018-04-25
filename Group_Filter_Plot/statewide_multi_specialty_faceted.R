### MENTAL HEALTH ###
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
  xlab("Specialty") +
  ylab("Number of Providers") +
  ggtitle("Statewide Mental HealthProviders Grouped by Similar Specialty") +
  scale_fill_manual(values = cols)