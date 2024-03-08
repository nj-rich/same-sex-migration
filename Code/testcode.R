#messing with arrow to better load stuff REMEMBER COLLECT FOR COMPUTATIONS

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
pq_path <- "/Users/njrich/Desktop/Econ495/same-sex-migration/Data/pull1"

pull1_csv %>%
  group_by(YEAR) %>%
  write_dataset(path = pq_path, format = "parquet")

#open parquet
pull1_pq <- open_dataset(pq_path)

df_pq <- pull1_pq

#test using/making/IDing partners
#ok this is currently broken but making progress 
#see error:
# Error in `compute.arrow_dplyr_query()`:
#   ! Invalid: Could not open Parquet input source '/Users/njrich/Desktop/Econ495/same-sex-migration/Data/pull1/codebook_pull1.xml': Parquet magic bytes not found in footer. Either the file is corrupted or this is not a parquet file.
# Run `rlang::last_trace()` to see where the error occurred.

partner <- pull1_pq %>%
  select(YEAR, SERIAL, PERNUM, SEX) %>%
  collect()


