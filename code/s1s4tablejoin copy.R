library("tidyverse")
library("dplyr")

#read in s1 and filter by soil

s1_data <- read_csv("s1_data.csv", col_types =
                      cols(
                        #.default = col_character(),
                        OXYGEN_CONCENTRATION = col_character(),
                        SALINITY_CONCENTRATION = col_character()))

#s1_data$OXYGEN_CONCENTRATION = as.character(s1_data$OXYGEN_CONCENTRATION)

#s1_data %>% 
#  mutate("OXYGEN_CONCENTRATION" = as.character(OXYGEN_CONCENTRATION))
  #convert(chr(OXYGEN_CONCENTRATION))

str(s1_data)

#read in s4

s4_data <- read_csv("s4_data.csv") 

head(s4_data)

#filter out NA's and try first ratio for s4
s4_data_test <- s4_data %>% 
  filter("Mapped to GEM catalogue" != "NA", "High quality reads sampled (up to 500K)" != "NA" ) %>% 
  mutate(ratio_GEM_to_reads = (`Mapped to GEM catalogue`)/(`High quality reads sampled (up to 500K)`))

# s4_data_test$division = (s4_data_test$`Mapped to GEM catalogue`/s4_data_test$`High quality reads sampled (up to 500K)`)


#join s1 and s4

s1_joined_s4 <- s1_data %>%
  full_join(s4_data_test, by = c("IMG_TAXON_ID" = "IMG Taxon id"))
head(s1_joined_s4)


#str(s1_joined_s4)

#new mutation for next ratio
s1_joined_s4_mut2 <- s1_joined_s4 %>% 
  mutate(ratio_NCBI_to_reads = (`Mapped to NCBI RefSeq`/`High quality reads sampled (up to 500K)`))

#last ratio mutation 
s1_joined_s4_mut3 <- s1_joined_s4_mut2 %>% 
  mutate(ratio_either_to_reads = (`Mapped to either`/`High quality reads sampled (up to 500K)`))

s1_joined_s4_final <- s1_joined_s4_mut3