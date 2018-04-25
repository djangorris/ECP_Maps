###### SINGLE COUNTY BY SINGLE SPECIALTY #####
selected_county <- "Larimer"
selected_specialty <- "003 Internal Medicine"
COUNTY_ALL <- ALL_county_specialty_count %>% 
  group_by(Specialty, County) %>% 
  filter(Specialty == selected_specialty, County == selected_county)
# plot
cols <- c("Anthem BCBS" = "blue", 
          "Bright" = "deeppink3", 
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(COUNTY_ALL, aes(x = Carrier, y = nproviders, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  xlab("Insurance Carrier") +
  ylab("Number of Providers") +
  ggtitle(str_c("Providers listed as ", '"', selected_specialty, '" in ', selected_county, " County ")) +
  scale_fill_manual(values = cols)