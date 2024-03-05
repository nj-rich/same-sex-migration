library(tidyverse)
install.packages("data.table")
library(data.table)

##figure out most efficient way to load data

#this works pretty fast
pull1 <- fread("/Users/njrich/Desktop/Econ495/Data/pull1/pull1.csv")

#try tidyverse method (should work well if not quite as well)
pull1_altload <- read_csv("/Users/njrich/Desktop/Econ495/Data/pull1/pull1.csv")
#ok this breaks use fread and get comfortable with it
