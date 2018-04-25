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
  xlab("Insurance Carrier") +
  ylab("Number of Providers") +
  ggtitle("Colorado Statewide Medical Providers") +
  scale_fill_manual(values = cols) +
  labs(caption = "Source: 2018 SERFF Health Plan Binder")