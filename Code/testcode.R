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

input_df <- df_samesex_mm
#yay mapping

gc()
#make state_years string for repeated use
df_state_years <- df_samesex %>%
  distinct(state_name, YEAR) %>%
  mutate(state_year = paste(state_name, YEAR, sep = "_"))

state_years <- df_state_years$state_year %>% unique()

#outer function (watch opposite sex df differences)
create_output <- function(input_df) {

#make state_years (note: watch handling general state_years string for dfs with missing state_years)
df <- input_df %>%
  mutate(state_year = paste(state_name, YEAR, sep = "_"))


#create export file paths
df_name_string <- deparse(substitute(input_df)) #convert df name to string for later file export
csv_filepath <- paste("C:\\Users\\njrich\\Desktop\\same-sex-migration\\W24_builds\\F24_validation\\", gsub("df_samesex_", "", df_name_string), ".csv")
stata_filepath <- paste("C:\\Users\\njrich\\Desktop\\same-sex-migration\\W24_builds\\F24_validation\\", gsub("df_samesex_", "", df_name_string), ".dta")

#inner function building export row by row- add if statement for stateyears not present

build_samesex_rows <- function(input_stateyear) {
small_df = df

state_year = input_stateyear

indv_state = substr(input_stateyear, 1, 2)
indv_year = substr(input_stateyear, 4, 8) %>%
  as.numeric()

if((indv_state %in% small_df$state_name) & (indv_year %in% small_df$YEAR)) {
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

#make fraction
rate = mig_to_state/tot_pot_mig
}
#for missing state-years
else{
  rate = NA
}

#build row to stack later (and fraction) - watch NAs/comparison check

df_row = data.frame(YEAR = indv_year,
                    state_name = indv_state,
                    staterate_year = rate)

return(df_row)
}

partial_output <- map(state_years, build_samesex_rows) %>% list_rbind()

#drop NAs (temporarily keep NAs for RCompare)
# partial_output <- partial_output %>%
#   filter(!is.na(staterate_year))

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

#Export
write.csv(output, csv_filepath)
write_dta(output, stata_filepath)

return(output)
}

test2 <- create_output(df_samesex_mm)
#function not actually faster? intriguing.
#still need to rCompare



#next steps: RCompare new methodology, adjust whether states are dropped by lack of same-sex individuals or lack of same-sex migrants


#use clean_names?

#oop what to do about NAs

#missing rCompare?
