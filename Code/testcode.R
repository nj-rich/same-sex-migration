#test (roughly) excluding too many gay individuals
gc()

testdata <- df_samesex %>%
  filter(in_samesex == 1) %>% 
  filter(AGE >= 30 & AGE <= 64) %>%
  filter(YEAR >= 2001 & YEAR <= 2015) #%>% 
 # filter(MARST == 4 | MARST == 5 | MARST == 6) #includes those divorced, widowed, never married/single (NOTE: this excludes those married, separated, blank/missing)

#filter by sample
df_samesex_mm_gen_t <- testdata #general sample
df_samesex_mm_m_t <- testdata %>% #men only
  filter(SEX.indv == 1)
df_samesex_mm_f_t <- testdata %>% #women only
  filter(SEX.indv == 2)

F24_mm_m_t <- create_output(df_samesex_mm_m_t, 2001, 2015)
F24_mm_f_t <- create_output(df_samesex_mm_f_t, 2001, 2015)
F24_mm_gen_t <- create_output(df_samesex_mm_gen_t, 2001, 2015)

#takeaway: still have more dropped observations than MM

#observing that my testplot is >5x in magnitude than replicated graph 
#(even though I have more missing) play around with weights (does not solve the issue)
