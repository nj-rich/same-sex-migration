#label legalization date from Gerstmann "2012" OG pqper (see issues)
gc()
df_samesex <- df_samesex %>%
  mutate(date_legalization = state_name) 

df_samesex <- df_samesex %>%
  mutate(date_legalization = case_when ( 
    date_legalization == "AL" ~ "2015",
    date_legalization == "AK" ~ "2014",
    date_legalization == "AZ" ~ "2014",
    date_legalization == "AR" ~ "2015",
    date_legalization == "CA" ~ "2013", #watch legalized/repealed issue
    date_legalization == "CO" ~ "2014",
    date_legalization == "CT" ~ "2008",
    date_legalization == "DE" ~ "2013",
    date_legalization == "DC" ~ "2009",
    date_legalization == "FL" ~ "2015",
    TRUE ~ date_legalization)) 

gc()
df_samesex <- df_samesex %>%
  mutate(date_legalization = case_when(
    date_legalization == "GA" ~ "2015",
    date_legalization == "HI" ~ "2013",
    date_legalization == "ID" ~ "2014",
    date_legalization == "IL" ~ "2013",
    date_legalization == "IN" ~ "2014",
    date_legalization == "IA" ~ "2009",
    date_legalization == "KS" ~ "2014",
    date_legalization == "KY" ~ "2015",
    date_legalization == "LA" ~ "2015",
    date_legalization == "ME" ~ "2012",
    TRUE ~ date_legalization)) 

gc()
df_samesex <- df_samesex %>%
  mutate(date_legalization = case_when(
    date_legalization == "MD" ~ "2012",
    date_legalization == "MA" ~ "2003",
    date_legalization == "MI" ~ "2015",
    date_legalization == "MN" ~ "2013",
    date_legalization == "MS" ~ "2015",
    date_legalization == "MO" ~ "2015",
    date_legalization == "MT" ~ "2014",
    date_legalization == "NE" ~ "2015",
    date_legalization == "NV" ~ "2014",
    date_legalization == "NH" ~ "2009",
    TRUE ~ date_legalization)) 

gc()
df_samesex <- df_samesex %>%
  mutate(date_legalization = case_when(
    date_legalization == "NJ" ~ "2013",
    date_legalization == "NM" ~ "2013",
    date_legalization == "NY" ~ "2011",
    date_legalization == "NC" ~ "2014",
    date_legalization == "ND" ~ "2015",
    date_legalization == "OH" ~ "2015",
    date_legalization == "OK" ~ "2014",
    date_legalization == "OR" ~ "2014",
    date_legalization == "PA" ~ "2014",
    date_legalization == "RI" ~ "2013",
    TRUE ~ date_legalization)) 

gc()
df_samesex <- df_samesex %>%
  mutate(date_legalization = case_when(
    date_legalization == "SC" ~ "2014",
    date_legalization == "SD" ~ "2015",
    date_legalization == "TN" ~ "2015",
    date_legalization == "TX" ~ "2015",
    date_legalization == "UT" ~ "2014",
    date_legalization == "VT" ~ "2009",
    date_legalization == "VA" ~ "2014",
    date_legalization == "WA" ~ "2012",
    date_legalization == "WV" ~ "2014",
    date_legalization == "WI" ~ "2014",
    date_legalization == "WY" ~ "2014",
    date_legalization == "PR" ~ "2015", #from googling
    date_legalization == "OMI" ~ "2015", #from guessing
    TRUE ~ date_legalization 
  ))

gc()
df_samesex <- df_samesex %>%
  mutate(date_legalization = as.numeric(date_legalization))
