### BINDING CARRIERS ###
ALL_county_specialty_count <- bind_rows(ANTHEM_county_specialty_count, 
                                        BRIGHT_county_specialty_count, 
                                        CIGNA_county_specialty_count, 
                                        DENVER_HEALTH_county_specialty_count, 
                                        KAISER_county_specialty_count, 
                                        RMHP_county_specialty_count)

ALL_statewide_specialty_count <- bind_rows(ANTHEM_statewide_specialty_count, 
                                           BRIGHT_statewide_specialty_count, 
                                           CIGNA_statewide_specialty_count, 
                                           DENVER_HEALTH_statewide_specialty_count, 
                                           KAISER_statewide_specialty_count, 
                                           RMHP_statewide_specialty_count)
ALL_county_specialty_count$Carrier <- as.factor(ALL_county_specialty_count$Carrier)
ALL_statewide_specialty_count$Carrier <- as.factor(ALL_statewide_specialty_count$Carrier)
ALL_county_specialty_count$County <- str_to_title(ALL_county_specialty_count$County)
### EXPORTING ###
write_csv(ALL_county_specialty_count, path = "Indiv/ALL_county_specialty_count.csv")
write_csv(ALL_statewide_specialty_count, path = "Indiv/ALL_statewide_specialty_count.csv")
