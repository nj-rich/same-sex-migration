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
rm(df_state_years)

#outer function (watch opposite sex df differences)
create_output <- function(input_df) {

#make state_years (note: watch handling general state_years string for dfs with missing state_years)
df <- input_df %>%
  mutate(state_year = paste(state_name, YEAR, sep = "_"))


#create export file paths
df_name_string <- deparse(substitute(input_df)) #convert df name to string for later file export
csv_filepath <- paste("C:\\Users\\njrich\\Desktop\\same-sex-migration\\W24_builds\\F24_validation\\", gsub("df_samesex_", "", df_name_string), ".csv", sep = "")
stata_filepath <- paste("C:\\Users\\njrich\\Desktop\\same-sex-migration\\W24_builds\\F24_validation\\", gsub("df_samesex_", "", df_name_string), ".dta", sep = "")

#inner function building export row by row

build_samesex_rows <- function(input_stateyear) {
small_df = df

state_year = input_stateyear

indv_state = substr(input_stateyear, 1, 2)
indv_year = substr(input_stateyear, 4, 8) %>%
  as.numeric()

if((indv_state %in% small_df$state_name) & (indv_year %in% small_df$YEAR)) { #output fraction IF have same-sex individuals; MOVE THIS IF STATEMENT DOWN, 

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

#MOVE IF STATEMENT DOWN HERE - FOR MM NA
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

#test differences with original method
F24_mm_m <- create_output(df_samesex_mm_m)
F24_mm_f <- create_output(df_samesex_mm_f)
F24_mm_gen <- create_output(df_samesex_mm_gen)

mod_F24_mm_m <- F24_mm_m %>%
  filter(!is.na(staterate_year)) %>%
  mutate(stateyear = paste(YEAR, state_name))
mod_F24_mm_f <- F24_mm_f %>%
  filter(!is.na(staterate_year)) %>%
  mutate(stateyear = paste(YEAR, state_name))
mod_F24_mm_gen <- F24_mm_gen %>%
  filter(!is.na(staterate_year)) %>%
  mutate(stateyear = paste(YEAR, state_name))

W24_mm_m <- read_csv("C:\\Users\\njrich\\Desktop\\same-sex-migration\\W24_builds\\mm_m.csv") %>%
  select(YEAR:time_leg_chunked) %>%
  mutate(stateyear = paste(YEAR, state_name))
W24_mm_f <- read_csv("C:\\Users\\njrich\\Desktop\\same-sex-migration\\W24_builds\\mm_f.csv") %>%
  select(YEAR:time_leg_chunked) %>%
  mutate(stateyear = paste(YEAR, state_name))
W24_mm_gen <- read_csv("C:\\Users\\njrich\\Desktop\\same-sex-migration\\W24_builds\\mm_gen.csv") %>%
  select(YEAR:time_leg_chunked) %>%
  mutate(stateyear = paste(YEAR, state_name))

compared_mm_m <- rCompare(mod_F24_mm_m, W24_mm_m, keys = c("YEAR", "state_name"), roundDigits = 6)
compared_mm_f <- rCompare(mod_F24_mm_f, W24_mm_f, keys = c("YEAR", "state_name"), roundDigits = 6)
compared_mm_gen <- rCompare(mod_F24_mm_gen, W24_mm_gen, keys = c("YEAR", "state_name"), roundDigits = 6)

mm_f_comp <- mod_F24_mm_f %>% select(stateyear) %>% filter(!(stateyear %in% W24_mm_f$stateyear))
mm_m_comp <- mod_F24_mm_f %>% select(stateyear) %>% filter(!(stateyear %in% W24_mm_m$stateyear))
mm_gen_comp <- mod_F24_mm_f %>% select(stateyear) %>% filter(!(stateyear %in% W24_mm_gen$stateyear))

#rCompare notes (NOT with MM):
#F24 f/m/gen is off by 10^-2 on all values - NOT BIG DEAL can be explained by x100 in original to get percent (and then rounding in testcode version by rCompare)
#F24 f has MT while W24 drops Montana - BIG DEAL data_cleaning version of code has bug in it - "MT" column got pushed after "WY" column so was dropped on "do the division"/select step (as of 9/20/24 line 458)

#still need to reconcile with MM what is dropped (on state-years and count LGBT individuals (hmm census method differences too)))

#next steps: fix if statement/decide NA dropping(see MM pages 5-methods- and 8-footnote on dropping and 9- some summary stats/table 1), re-run regression code see if any differences, adjust census same-sex counts to get closer to MM (part of adjusting whether states are dropped by lack of same-sex individuals or lack of same-sex migrants)


#use clean_names?

#oop what to do about NAs

#missing rCompare?
