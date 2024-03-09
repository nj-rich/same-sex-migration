#messing with arrow to better load stuff REMEMBER COLLECT FOR COMPUTATIONS
library(tidyverse)

#to help deal with large data files
#install.packages("data.table") #for fread
#library(data.table)
install.packages("arrow") #for parquet
library(arrow)

#loading data
pull1_csv <- open_dataset(
  sources = "/Users/njrich/Desktop/Econ495/same-sex-migration/Data/pull1/pull1.csv",
  col_types = schema(CBSERIAL = int64(), COUPLETYPE = int64(), SSMC = int64(), 
                     MIGPLAC1 = int64(), MIGCOUNTY1 = int64(), SPMPOV = int64(),
                     OFFPOV = int64()),
                     format = "csv") 
#note: some col types aren't labeled bc initial rows are blank; keep in mind
#note: can stay here but parquet might help

#make parquet
#pq_path <- "/Users/njrich/Desktop/Econ495/same-sex-migration/Data/pull1/parquet"

#pull1_csv %>%
#  group_by(YEAR) %>%
#  write_dataset(path = pq_path, format = "parquet")

#open parquet
#pq_path <- "/Users/njrich/Desktop/Econ495/same-sex-migration/Data/pull1/parquet"
#pull1_pq <- open_dataset(pq_path)

#df_pq <- pull1_pq

#maybe no need parquet?

#test using/making/IDing partners

partner <- pull1_csv %>%
  select(YEAR, SERIAL, PERNUM, SEX) %>% #rename sex var for clarity?
  compute()

  
df_partners <- pull1_csv %>%
  left_join(partner, join_by(YEAR, SERIAL, SPLOC == PERNUM)) %>% #WATCH CLARITY WHERE SPLOC IS
  compute()

#AND BOOM WE HAVE IT YAY ARROW WATCH IF MERGE WORKED (AND CHECK)


