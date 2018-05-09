install.packages("readxl")
install.packages("tidyverse")
install.packages('ggmap')
install.packages('purrr')
install.packages("stringr")
install.packages("magick")
install.packages("here")
install.packages("extrafont") # fonts for plots

library(readxl)
library(tidyverse)
library(ggmap)
library(purrr)
library(knitr)
library(ggplot2)
library(stringr)
library(magick)
library(here)
library(magrittr)
library(extrafont)

# ECP Map theme
theme_ECP_maps <- theme(plot.margin = margin(10, 10, 10, 10),
      plot.title = element_text(family = "Arial Narrow",
                                color="grey10",
                                size = 18,
                                hjust=0),
      strip.text.x = element_text(size = 14,
                                  face = "bold"),
      panel.spacing.x=unit(0.2, "lines"),
      panel.spacing.y=unit(0.5, "lines"),
      legend.position = "none",
      plot.caption = element_text(family = "Arial",
                                  size = 12,
                                  color = "grey50",
                                  hjust = 0.5))

font_import() # import all your fonts
fonts() #get a list of fonts
fonttable()
fonttable()[40:45,] # very useful table listing the family name, font name etc
