#need test turning ultimate filtered data into clean data into FUNCTION....
#SIKE STILL NEED TO FIX

gc()

df <- df_samesex_mm

#make year totals excluding each state (no migrant restrictions)

df_yeartotals <- df

state_names <- unique(df$state_name)

indv_names <- paste(state_names, "excluded_indv", sep = "_")

for(i in 1:length(state_names)) {
  df_yeartotals <- df_yeartotals %>% #restrict this to gay earlier?
    mutate(column = if_else(state_name != state_names[i], in_samesex_weighted, 0)) %>%
    rename(!!indv_names[i] := column) #thank you chatgpt
}

gc()
total_names <- paste(state_names, "excluded_total", sep = "_")

for(i in 1:length(state_names)) {
  col_name <- indv_names[i] #thank you data.frame
  
  df_yeartotals <- df_yeartotals %>% 
    group_by(YEAR) %>% 
    mutate(columned = sum(!!sym(col_name), na.rm = T)) %>% #this seems to work oi thanks chatgpt, just missing na.rm = T? why work Mac earlier?
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
  left_join(df_yeartotals, join_by(YEAR, state_name), multiple = "any") #yay get rid of duplicates

samesex_staterate <- merged_totals %>% #oopsy amount of variable names
  pivot_wider(names_from = state_name, values_from = state_total) %>%
  replace(is.na(samesex_staterate), 0) #coerce missing values to 0

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
  rename(staterate_year = value) 

#missing value issue