#need test turning ultimate filtered data into clean data into FUNCTION....
#SIKE STILL NEED TO FIX
#test pull3

# gc()
# 
# pull3_csv <- fread("C:\\Users\\njrich\\Downloads\\pull3.csv")
# 
# gc()
# pull3_csv <- pull3_csv %>%
#   select(-SAMPLE, -CBSERIAL, -HHWT, -CLUSTER, -STRATA, -GQ) %>%
#   filter(SPLOC != 0) #filter out people not in relationships
# 
# gc()
# df_samesex <- pull3_csv %>% 
#   mutate(in_samesex = if_else(SEX == SEX_SP, 1, 0)) %>% #note: I am not seeing any 9s in my filtered data here
#   mutate(in_samesex_weighted = in_samesex * PERWT)
# 
# #my left_join doesn't seem to be the problem, consistent results across use of pull3 and pull1 methodology 
# 
# rm(pull3_csv)
# 

### FUNCTIONALIZE/MAP MAKE LIFE EASIER

##MARCEN REPLICATION

# Filter data to match Marcén/Morales target population
# ```{r, include = F}
gc()

df_samesex_mm <- df_samesex %>%
  filter(in_samesex == 1) %>% 
  filter(AGE >= 30 & AGE <= 64) %>%
  filter(YEAR >= 2001 & YEAR <= 2015) %>% 
  filter(MARST == 4 | MARST == 5 | MARST == 6) #includes those divorced, widowed, never married/single (NOTE: this excludes those married, separated, blank/missing)

#filter by sample
df_samesex_mm_gen <- df_samesex_mm #general sample
df_samesex_mm_m <- df_samesex_mm %>% #men only
  filter(SEX.indv == 1)
df_samesex_mm_f <- df_samesex_mm %>% #women only
  filter(SEX.indv == 2)

#next steps: adjust filters to exclude individuals mis-identified as partners by IPUMS
# ```
# 
# ##EXTENSION - 2001 - 2019
# ```{r, include = F}
gc()

df_samesex_2019 <- df_samesex %>%
  filter(in_samesex == 1) %>% 
  filter(AGE >= 30 & AGE <= 64) %>%
  filter(YEAR >= 2001 & YEAR <= 2019) %>% 
  filter(MARST == 4 | MARST == 5 | MARST == 6) #includes those divorced, widowed, never married/single (NOTE: this excludes those married, separated, blank/missing)

#filter by sample
df_samesex_2019_gen <- df_samesex_2019 #general sample
df_samesex_2019_m <- df_samesex_2019 %>% #men only
  filter(SEX.indv == 1)
df_samesex_2019_f <- df_samesex_2019 %>% #women only
  filter(SEX.indv == 2)
# 
# ```
# 
# ##EXTENSION - 2001 - 2015 by income (USE OFFICIAL METRICS IN THE FUTURE SAMPLES TOO SMALL COME BACK LATER
# ```{r, include = F}
gc()

df_samesex_inc <- df_samesex %>%
  filter(in_samesex == 1) %>% 
  filter(AGE >= 30 & AGE <= 64) %>%
  filter(YEAR >= 2001 & YEAR <= 2015) %>% 
  filter(MARST == 4 | MARST == 5 | MARST == 6) #includes those divorced, widowed, never married/single (NOTE: this excludes those married, separated, blank/missing)


df_samesex_inc <- df_samesex_inc %>%
  mutate(inc_class_year = case_when( #data in current dollars from IRS, below 50th percentile = 1, higher income = 2
    YEAR == 2001 & INCTOT < 31418 ~ 1,
    YEAR == 2002 & INCTOT < 31299 ~ 1,
    YEAR == 2003 & INCTOT < 31447 ~ 1,
    YEAR == 2004 & INCTOT < 32622 ~ 1,
    YEAR == 2005 & INCTOT < 33484 ~ 1,
    YEAR == 2006 & INCTOT < 34417 ~ 1,
    YEAR == 2007 & INCTOT < 35541 ~ 1,
    YEAR == 2008 & INCTOT < 35340 ~ 1,
    YEAR == 2009 & INCTOT < 34156 ~ 1,
    YEAR == 2010 & INCTOT < 34338 ~ 1,
    YEAR == 2011 & INCTOT < 34823 ~ 1,
    YEAR == 2012 & INCTOT < 36055 ~ 1,
    YEAR == 2013 & INCTOT < 36841 ~ 1,
    YEAR == 2014 & INCTOT < 38173 ~ 1,
    YEAR == 2015 & INCTOT < 39275 ~ 1,
    TRUE ~ 2
  )) 

df_samesex_inc_1 <- df_samesex_inc %>%
  filter(inc_class_year == 1) 


df_samesex_inc_2 <- df_samesex_inc %>%
  filter(inc_class_year == 2) 
# ```
# 
# 
# ##MARCEN BUT STRAIGHT COUPLES
# ```{r, include = F}
gc()

df_samesex_st <- df_samesex %>%
  filter(in_samesex == 0) %>% 
  mutate(in_samesex_weighted = PERWT) %>% 
  filter(AGE >= 30 & AGE <= 64) %>%
  filter(YEAR >= 2001 & YEAR <= 2015) %>% 
  filter(MARST == 4 | MARST == 5 | MARST == 6) #includes those divorced, widowed, never married/single (NOTE: this excludes those married, separated, blank/missing)

#filter by sample
df_samesex_st_gen <- df_samesex_st #general sample
df_samesex_st_m <- df_samesex_st %>% #men only
  filter(SEX.indv == 1)
df_samesex_st_f <- df_samesex_st %>% #women only
  filter(SEX.indv == 2)
# ```
# 
# 
# final division and cleaning (see MM page 5 under the equation)
# 
# ```{r, include = F}
gc()

df <- df_samesex_inc_2

#make year totals excluding each state (no migrant restrictions)

df_yeartotals <- df

state_names <- unique(df$state_name)

indv_names <- paste(state_names, "excluded_indv", sep = "_")

for(i in 1:length(state_names)) {
  df_yeartotals <- df_yeartotals %>% 
    mutate(column = if_else(state_name != state_names[i], in_samesex_weighted, 0)) %>%
    rename(!!indv_names[i] := column) 
}

gc()
total_names <- paste(state_names, "excluded_total", sep = "_")

for(i in 1:length(state_names)) {
  col_name <- indv_names[i] 
  
  df_yeartotals <- df_yeartotals %>% 
    group_by(YEAR) %>% 
    mutate(columned = sum(!!sym(col_name), na.rm = T)) %>% 
    ungroup() %>%
    rename(!!total_names[i] := columned)
}

df_yeartotals <- df_yeartotals %>%
  select(YEAR, state_name, AL_excluded_total:WY_excluded_total)

#make state year totals

df_statetotals <- df %>%
  filter(MIGPLAC1 > 0 & MIGPLAC1 < 57) %>%
  group_by(YEAR, state_name) %>%
  summarize(state_total = sum(in_samesex_weighted, na.rm = T)) %>%
  ungroup()

#some states don't exist here so convert later to 0

#set up division

merged_totals <- df_statetotals %>%
  left_join(df_yeartotals, join_by(YEAR, state_name), multiple = "any") #get rid of duplicates

samesex_staterate <- merged_totals %>% 
  pivot_wider(names_from = state_name, values_from = state_total) %>%
  mutate_all(~replace(., is.na(.), 0)) #coerce missing values to 0

#do the division

for(i in 1:length(state_names)) {
  state = state_names[i]
  total = total_names[i]
  
  samesex_staterate <- samesex_staterate %>% 
    mutate(!!state := !!sym(state)/!!sym(total))
  
}

samesex_staterate <- samesex_staterate %>%
  select(YEAR, AK:WY) %>%
  pivot_longer(AK:WY, names_to = "state_name") %>%
  rename(staterate_year = value) %>%
  mutate(staterate_year = staterate_year * 100)
rm(df, merged_totals, df_statetotals, df_yeartotals, col_name, i, indv_names, state, state_names, total, total_names)

gc()


#ID key variables to merge back in
extra_variables <- df_samesex %>% 
  distinct(YEAR, state_name, time_since_legalization)

#merge back in 

output <-samesex_staterate %>%
  left_join(extra_variables, join_by(YEAR, state_name)) %>%
  left_join(FRED, join_by(YEAR, state_name))

#make dummy variables for 1-2, 3-4, 5-6, >7 years 
output <- output %>%
  mutate(time_leg_chunked = case_when(
    time_since_legalization == 1 ~ 2,
    time_since_legalization == 2 ~ 2,
    time_since_legalization == 3 ~ 4,
    time_since_legalization == 4 ~ 4,
    time_since_legalization == 5 ~ 6,
    time_since_legalization == 6 ~ 6,
    time_since_legalization >= 7 ~ 7,
  ))



rm(samesex_staterate, extra_variables)

#next steps: functionalize, adjust whether states are dropped by lack of same-sex individuals or lack of same-sex migrants, try building new dataframe technique (building row by row) instead of pivot technique
# ```
# 
# Export
# ```{r, include = F}
gc()
write.csv(output, "C:\\Users\\njrich\\Desktop\\same-sex-migration\\inc_2.csv")
write_dta(output, "C:\\Users\\njrich\\Desktop\\same-sex-migration\\inc_2.dta") #fill in rest by gender

```