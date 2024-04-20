#test making state level pop estimates including state var

gc()

state_names <- unique(df_samesex_mm$state_name)

indv_names <- paste0(state_names, "exclude_indv")
for(i in 1:length(state_names)) {
  df_samesex_mm <- df_samesex_mm %>%
    mutate(exclude_indv = if_else(state_name != state_names[i], in_samesex_weighted, 0)) %>%
    rename()
  
}
