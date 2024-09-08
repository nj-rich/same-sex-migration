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

# final division and cleaning (see MM page 5 under the equation)
# 

gc()

df <- df_samesex_mm

#make year totals excluding each state (no migrant restrictions)
# 
# df_yeartotals <- df
# 
# state_names <- unique(df$state_name)
# 
# indv_names <- paste(state_names, "excluded_indv", sep = "_")
# 
# for(i in 1:length(state_names)) {
#   df_yeartotals <- df_yeartotals %>% 
#     mutate(column = if_else(state_name != state_names[i], in_samesex_weighted, 0)) %>%
#     rename(!!indv_names[i] := column) 
# }
# 
# gc()
# total_names <- paste(state_names, "excluded_total", sep = "_")
# 
# for(i in 1:length(state_names)) {
#   col_name <- indv_names[i] 
#   
#   df_yeartotals <- df_yeartotals %>% 
#     group_by(YEAR) %>% 
#     mutate(columned = sum(!!sym(col_name), na.rm = T)) %>% 
#     ungroup() %>%
#     rename(!!total_names[i] := columned)
# }
# 
# df_yeartotals <- df_yeartotals %>%
#   select(YEAR, state_name, AL_excluded_total:WY_excluded_total)
# 
# #make state year totals
# 
# df_statetotals <- df %>%
#   filter(MIGPLAC1 > 0 & MIGPLAC1 < 57) %>%
#   group_by(YEAR, state_name) %>%
#   summarize(state_total = sum(in_samesex_weighted, na.rm = T)) %>%
#   ungroup()
# 
# #some states don't exist here so convert later to 0
# 
# #set up division
# 
# merged_totals <- df_statetotals %>%
#   left_join(df_yeartotals, join_by(YEAR, state_name), multiple = "any") #get rid of duplicates
# 
# samesex_staterate <- merged_totals %>% 
#   pivot_wider(names_from = state_name, values_from = state_total) %>%
#   mutate_all(~replace(., is.na(.), 0)) #coerce missing values to 0
# 
# #do the division
# 
# for(i in 1:length(state_names)) {
#   state = state_names[i]
#   total = total_names[i]
#   
#   samesex_staterate <- samesex_staterate %>% 
#     mutate(!!state := !!sym(state)/!!sym(total))
#   
# }
# 
# samesex_staterate <- samesex_staterate %>%
#   select(YEAR, AK:WY) %>%
#   pivot_longer(AK:WY, names_to = "state_name") %>%
#   rename(staterate_year = value) %>%
#   mutate(staterate_year = staterate_year * 100)
# rm(df, merged_totals, df_statetotals, df_yeartotals, col_name, i, indv_names, state, state_names, total, total_names)
# 
# gc()

#yay mapping

input_df <- df_samesex_mm

#outer function (watch opposite sex df differences)
create_output <- function(input_df) {

df <- input_df %>%
  mutate(state_year = paste(state_name, YEAR, sep = "_"))

state_years <- df$state_year %>% unique()

##^^simplify

#inner function

build_samesex_rows <- function(input_stateyear) {
small_df = df

state_year = input_stateyear

indv_state = substr(input_stateyear, 1, 2)
indv_year = substr(input_stateyear, 4, 8) %>%
  as.numeric()

#count total potential migrants to state (all same-sex indv in given year excluding those in destination state)
tot_pot_mig_build <- small_df %>%
  filter(YEAR == indv_year) %>%
  filter(state_name != indv_state) %>%
  summarize(count = sum(in_samesex_weighted))

tot_pot_mig <- tot_pot_mig_build$count[1]

#count actual migrants to state

mig_to_state_build <- small_df %>%
  filter(YEAR == indv_year) %>%
  filter(state_name == indv_state) %>%
  filter(MIGPLAC1 > 0 & MIGPLAC1 < 57) %>%
  summarize(count = sum(in_samesex_weighted))

mig_to_state = mig_to_state_build$count[1]

#build row to stack later (and fraction) - watch NAs/comparison check

df_row = data.frame(YEAR = indv_year,
                    state_name = indv_state,
                    staterate_year = mig_to_state/tot_mig)

return(df_row)
}

partial_output <- map(state_years, build_samesex_rows) %>% list_rbind()

#ID key variables to merge back in
extra_variables <- df_samesex %>% 
  distinct(YEAR, state_name, time_since_legalization)

#merge back in 

output <-partial_output %>%
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
return(output)

#export here?
}

test2 <- create_output(df_samesex_mm)
#function not actually faster? intriguing.
#time_since_legalization variable is broken; need to fix
#watch rCompare; tidyverse function identification



#next steps: functionalize, adjust whether states are dropped by lack of same-sex individuals or lack of same-sex migrants, try building new dataframe technique (building row by row) instead of pivot technique
# ```
# 
# Export
# ```{r, include = F}
# gc()
# write.csv(output, "C:\\Users\\njrich\\Desktop\\same-sex-migration\\inc_2.csv")
# write_dta(output, "C:\\Users\\njrich\\Desktop\\same-sex-migration\\inc_2.dta") #fill in rest by gender


#use clean_names?

#oop what to do about NAs

#missing rCompare?
