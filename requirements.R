install.packages("readxl")
install.packages("tidyverse")
install.packages('ggmap')
install.packages('purrr')
install.packages("stringr")
install.packages("magick")
install.packages("here")
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

install.packages("extrafont")
library(extrafont)
font_import() # import all your fonts
fonts() #get a list of fonts
fonttable()
fonttable()[40:45,] # very useful table listing the family name, font name etc
