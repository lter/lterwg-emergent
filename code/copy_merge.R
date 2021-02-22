library(dplyr)
library(readr)
soilFieldChem <- read.csv(file = 'soilFieldChem.csv')
nTransData <- read.csv(file = 'sls_nTransData_20210206.csv')
truncated_nTransData <- nTransData[ , c("sampleID","kclAmmoniumNConc", "ammoniumNRepNum","kclNitrateNitriteNConc")]
df <- soilFieldChem %>% right_join(truncated_nTransData, by = "sampleID")
#df1 <- merge(x = soilFieldChem, y = nTransData[ , c("kclAmmoniumNConc", "ammoniumNRepNum","kclNitrateNitriteNConc")], 
#             by = c("sampleID"), all.x=TRUE)
print(df)
write.csv(df,"merged_tables.csv")