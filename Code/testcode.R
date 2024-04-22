#test making state level pop estimates including state var
df_samesex_mm <- fread("/Users/njrich/Desktop/Econ495/same-sex-migration/test_data.csv") #read in test_code on mac

gc() 
df <- df_samesex_mm

state_names <- unique(df$state_name)

indv_names <- paste(state_names, "excluded_indv", sep = "_")

for(i in 1:length(state_names)) {
  df <- df %>% #restrict this to gay earlier?
    mutate(column = if_else(state_name != state_names[i], in_samesex_weighted, 0)) %>%
    rename(!!indv_names[i] := column) #thank you chatgpt
}

total_names <- paste(state_names, "excluded_total", sep = "_")

for(i in 1:length(state_names)) {
    col_name <- indv_names[i] #thank you data.frame
    
    df <- df %>% 
      group_by(YEAR) %>% 
      mutate(columned = sum(!!sym(col_name))) %>% #this seems to work oi thanks chatgpt
      ungroup() %>%
      rename(!!total_names[i] := columned)
}


#line up state and overall year totals (does not seem very efficient:()
state_year_totals <- df %>%
  group_by(YEAR, state_name) %>%
  summarize(samesex_state_count = sum(in_samesex_weighted, na.rm = T)) %>% #WATCH NO USE SPECIAL COUNT HERE
  ungroup()


year_totals <- df %>%
  select(YEAR, state_name, RI_excluded_total:OK_excluded_total) 

merged_totals <- state_year_totals %>%
  left_join(year_totals, join_by(YEAR, state_name), multiple = "any") #yay get rid of duplicates

#do the division
samesex_staterate <- merged_totals %>% #oopsy amount of variable names
  pivot_wider(names_from = state_name, values_from = samesex_state_count)

for(i in 1:length(state_names)) {
  state = state_names[i]
  total = total_names[i]
  
  samesex_staterate <- samesex_staterate %>% 
    mutate(!!state := !!sym(state)/!!sym(total))
  
}

#clean up variables pivot long to get back to beginning:)

samesex_staterate <- samesex_staterate %>%
  select(YEAR, AK:WY) %>%
  pivot_longer(AK:WY, names_to = "state_name")

rm(df, merged_totals, state_year_totals, year_totals, col_name, i, indv_names, state, state_names, total, total_names)
#AND IT WORKS NOW MOVING ON NEXT STEP DIVISION:)





##IGNORE BELOW
samesex_staterate <- df_samesex_mm %>%
  group_by(YEAR, state_name) %>%
  summarize(samesex_state_count = sum(in_samesex_weighted, na.rm = T)) %>% #note: weight implementation means SE unreliable
  ungroup() %>%
  group_by(YEAR) %>%
  mutate(year_totals = sum(samesex_state_count)) %>%
  ungroup() %>%
  mutate(staterate_year = samesex_state_count/year_totals) %>%
  select(YEAR, state_name, staterate_year)
