##### SINGLE COUNTY TOTAL  #####
county_selected <- "Summit"
SINGLE_COUNTY <- ALL_county_specialty_count %>% 
  filter(County == county_selected) %>% 
  summarise(Total = sum(nproviders, na.rm = TRUE))
cols <- c("Anthem BCBS" = "blue", 
          "Bright" = "deeppink3", 
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(SINGLE_COUNTY, aes(x = Carrier, y = Total, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  xlab("Insurance Carrier") +
  ylab("Number of Providers") +
  ggtitle(str_c(county_selected, " County Medical Providers")) +
  scale_fill_manual(values = cols)