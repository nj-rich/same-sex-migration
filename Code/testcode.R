#need test turning ultimate filtered data into clean data into FUNCTION....
#SIKE STILL NEED TO FIX
#test pull3

gc()

pull3_csv <- fread("C:\\Users\\njrich\\Downloads\\pull3.csv")

gc()
pull3_csv <- pull3_csv %>%
  select(-SAMPLE, -CBSERIAL, -HHWT, -CLUSTER, -STRATA, -GQ) %>%
  filter(SPLOC != 0) #filter out people not in relationships

gc()
df_samesex <- pull3_csv %>% 
  mutate(in_samesex = if_else(SEX == SEX_SP, 1, 0)) %>% #note: I am not seeing any 9s in my filtered data here
  mutate(in_samesex_weighted = in_samesex * PERWT)

#my left_join doesn't seem to be the problem, consistent results across use of pull3 and pull1 methodology 

rm(pull3_csv)