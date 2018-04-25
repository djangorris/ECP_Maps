###### STATEWIDE BY SPECIALTY #####
selected_specialty <- "003 Internal Medicine"
STATEWIDE <- ALL_statewide_specialty_count %>% 
  filter(Specialty == selected_specialty)
# plot
cols <- c("Anthem BCBS" = "blue", 
          "Bright" = "deeppink3", 
          "Cigna" = "forestgreen",
          "Denver Health" = "navyblue",
          "Kaiser" = "deepskyblue2",
          "RMHP" = "darkorange")
ggplot(STATEWIDE, aes(x = Carrier, y = count, fill = Carrier)) +
  geom_bar(position="dodge", stat="identity") +
  xlab("Insurance Carrier") +
  ylab("Number of Providers") +
  ggtitle(str_c("Providers listed as ", '"', selected_specialty, '" in Colorado')) +
  scale_fill_manual(values = cols)
