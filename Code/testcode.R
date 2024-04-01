#in general thinK: test code on sample first?

library(tidyverse)
library(data.table)

#key to fread on windows: download data first
pull1_csv <- fread("C:\\Users\\njrich\\Downloads\\pull1.csv")

partner <- pull1_csv %>%
  select(YEAR, SERIAL, PERNUM, SEX) 

gc()
df_partners <- pull1_csv %>%
  left_join(partner, join_by(YEAR, SERIAL, SPLOC == PERNUM), suffix = c(".indv", ".partner"))

gc()
df_samesex <- df_partners %>% #WATCH CLARITY WHERE SPLOC IS
  mutate(in_samesex = case_when(
    (SEX.indv == 1) & (SEX.partner == 1) ~ 1, #gay
    (SEX.indv == 2) & (SEX.partner == 2) ~ 1, #gay
    (SEX.indv == 2) & (SEX.partner == 1) ~ 0, #straight
    (SEX.indv == 1) & (SEX.partner == 2) ~ 0, #straight
    (SEX.indv == 9) | (SEX.partner == 9) ~ NA #NA 
  ))

rm(partner, df_partners, pull1_csv)

gc()
#running now, some issues with some code seeming to be ignored; maybe chunk even more aggressively
df_samesex <- df_samesex %>%
  mutate(state_name = NA) %>% #ok this seems to work
  mutate(state_name = case_when( 
    STATEFIP == 1 ~ "AL",
    STATEFIP == 2 ~ "AK",
    STATEFIP == 4 ~ "AZ",
    STATEFIP == 5 ~ "AR",
    STATEFIP == 6 ~ "CA",
    STATEFIP == 8 ~ "CO",
    STATEFIP == 9 ~ "CT",
    STATEFIP == 10 ~ "DE")) %>%
  mutate(state_name = case_when(
    STATEFIP == 11 ~ "DC",
    STATEFIP == 12 ~ "FL",
    STATEFIP == 13 ~ "GA",
    STATEFIP == 15 ~ "HI",
    STATEFIP == 16 ~ "ID",
    STATEFIP == 17 ~ "IL",
    STATEFIP == 18 ~ "IN",
    STATEFIP == 19 ~ "IA",
    STATEFIP == 20 ~ "KS")) %>%
  mutate(state_name = case_when(
    STATEFIP == 21 ~ "KY",
    STATEFIP == 22 ~ "LA",
    STATEFIP == 23 ~ "MI",
    STATEFIP == 24 ~ "MD",
    STATEFIP == 25 ~ "MA",
    STATEFIP == 26 ~ "ME",
    STATEFIP == 27 ~ "MN",
    STATEFIP == 28 ~ "MS",
    STATEFIP == 29 ~ "MO",
    STATEFIP == 30 ~ "MT")) %>%
  mutate(state_name = case_when(
    STATEFIP == 31 ~ "NE",
    STATEFIP == 32 ~ "NV",
    STATEFIP == 33 ~ "NH",
    STATEFIP == 34 ~ "NJ",
    STATEFIP == 35 ~ "NM",
    STATEFIP == 36 ~ "NY",
    STATEFIP == 37 ~ "NC",
    STATEFIP == 38 ~ "ND",
    STATEFIP == 39 ~ "OH",
    STATEFIP == 40 ~ "OK")) %>%
  mutate(state_name = case_when(
    STATEFIP == 41 ~ "OR",
    STATEFIP == 42 ~ "PA",
    STATEFIP == 44 ~ "RI",
    STATEFIP == 45 ~ "SC",
    STATEFIP == 46 ~ "SD",
    STATEFIP == 47 ~ "TN",
    STATEFIP == 48 ~ "TX",
    STATEFIP == 49 ~ "UT",
    STATEFIP == 50 ~ "VT",
    STATEFIP == 51 ~ "VA",
    STATEFIP == 53 ~ "WA",
    STATEFIP == 54 ~ "WV",
    STATEFIP == 55 ~ "WI",
    STATEFIP == 56 ~ "WY",
    STATEFIP == 72 ~ "PR",
    STATEFIP == 97 ~ "OMI", #Overseas Military Installations
    STATEFIP == 99 ~ NA #redundant now
  )) 

#remove og STATEFIP var? drop other vars?

#break this up too
gc()
#this runs but seems to have similar dropping issues as well yay chunking
df_samesex <- df_samesex %>%
  mutate(date_legalization = NA) %>%
  mutate(date_legalization = case_when ( #label legalization date from Gerstmann 2012 OG pqper
    state_name == "AL" ~ 2015,
    state_name == "AK" ~ 2014,
    state_name == "AZ" ~ 2014,
    state_name == "AR" ~ 2015,
    state_name == "CA" ~ 2013, #watch leglized/repealed issue
    state_name == "CO" ~ 2014,
    state_name == "CT" ~ 2008,
    state_name == "DE" ~ 2013,
    state_name == "DC" ~ 2009,
    state_name == "FL" ~ 2015)) %>%
  mutate(date_legalization = case_when(
    state_name == "GA" ~ 2015,
    state_name == "HI" ~ 2013,
    state_name == "ID" ~ 2014,
    state_name == "IL" ~ 2013,
    state_name == "IN" ~ 2014,
    state_name == "IA" ~ 2009,
    state_name == "KS" ~ 2014,
    state_name == "KY" ~ 2015,
    state_name == "LA" ~ 2015,
    state_name == "ME" ~ 2012)) %>%
  mutate(date_legalization = case_when(
    state_name == "MD" ~ 2012,
    state_name == "MA" ~ 2003,
    state_name == "MI" ~ 2015,
    state_name == "MN" ~ 2013,
    state_name == "MS" ~ 2015,
    state_name == "MO" ~ 2015,
    state_name == "MT" ~ 2014,
    state_name == "NE" ~ 2015,
    state_name == "NV" ~ 2014,
    state_name == "NH" ~ 2009)) %>%
  mutate(date_legalization = case_when(
    state_name == "NJ" ~ 2013,
    state_name == "NM" ~ 2013,
    state_name == "NY" ~ 2011,
    state_name == "NC" ~ 2014,
    state_name == "ND" ~ 2015,
    state_name == "OH" ~ 2015,
    state_name == "OK" ~ 2014,
    state_name == "OR" ~ 2014,
    state_name == "PA" ~ 2014,
    state_name == "RI" ~ 2013)) %>%
  mutate(date_legalization = case_when(
    state_name == "SC" ~ 2014,
    state_name == "SD" ~ 2015,
    state_name == "TN" ~ 2015,
    state_name == "TX" ~ 2015,
    state_name == "UT" ~ 2014,
    state_name == "VT" ~ 2009,
    state_name == "VA" ~ 2014,
    state_name == "WA" ~ 2012,
    state_name == "WV" ~ 2014,
    state_name == "WI" ~ 2014,
    state_name == "WY" ~ 2014,
    state_name == "PR" ~ 2015, #from googling
    state_name == "OMI" ~ 2015 #from guessing
  )) 

gc()
df_samesex <- df_samesex %>%
  mutate(time_since_legalization = YEAR - date_legalization) #make time_since variable

#question: will regressions/summary stats even run?? #WATCH WEIGHTING/OTHER CLEANING

gc()
df_samesex %>%
  summarize(percent_samesex = sum(in_samesex, na.rm = T) / n()) 
#ok yeah yay this works need to check weighting/variable interpretation is correct; talk to other researchers!!