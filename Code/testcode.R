#test making state level pop estimates including state var

gc()

state_names <- unique(df_samesex_mm$state_name)

indv_names <- paste(state_names, "excluded_indv", sep = "_")

for(i in 1:length(state_names)) {
  df_samesex_mm <- df_samesex_mm %>% #restrict this to gay earlier?
    mutate(column = if_else(state_name != state_names[i], in_samesex_weighted, 0)) %>%
    rename(!!indv_names[i] := column) #thank you chatgpt
}


total_names <- paste(state_names, "excluded_total", sep = "_")

for(i in 1:length(state_names)) {
    col_name <- indv_names[i] #thank you data.frame
    col <- df_samesex_mm[[col_name]]
    
    df_samesex_mm <- df_samesex_mm %>% 
    group_by(YEAR) %>%
    mutate(column = sum(col)) %>%
    rename(!!total_names[i] := column)%>% #thank you chatgpt
    ungroup()
}

test <- indv_names[1]
df_samesex_mm[, ..test, drop = F] #.. was working earlier, not anymore

df_samesex_mm[[test]]


##MAKING PROGRESS ISH KEEP FIXING LOOP ABOVE

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

test_data <- df_samesex %>%
  filter(in_samesex == 1)

write.csv(test_data, "C:\\Users\\njrich\\Desktop\\same-sex-migration\\test_data.csv")
