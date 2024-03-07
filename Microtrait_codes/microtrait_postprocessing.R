# Calling data ####

library(dplyr)
library(tidyverse)

setwd("C:/luciana_datos/UCI/Project_2 (microtrait-dement)/MAG_database/MAG_Loma/microtrait_results")
setwd("C:/luciana_datos/UCI/Project_2 (microtrait-dement)/MAG_database/MAGs_burnt/microtrait_results")

genomes_files = list.files()

# Extracting traits from rds files ####

# Loop to extract granularity 3 traits ####

c = list()
d = list()
e = list()
f = list()

for (i in 1:length(genomes_files)) {
  df_with_special_characters <- readRDS(genomes_files[i])
  a   = t(as.data.frame(df_with_special_characters[["trait_counts_atgranularity3"]])[,2])
  b   = df_with_special_characters[["id"]]
  a.1 = df_with_special_characters[["ogt"]]
  b.1 = df_with_special_characters[["growthrate_d"]]
  c[[i]] = (list(b))
  d[[i]] = as.data.frame(list(a))
  e[[i]] = a.1
  f[[i]] = b.1
}

df   = do.call("rbind",c)
df.1 = do.call("rbind",d)
df.2 = as.data.frame(sapply(e, function(x) ifelse(is.null(x), NA, x)))
df.2[nrow(df.2) + 1,] <- NA # optional steps
df.3 = as.data.frame(sapply(f, function(x) ifelse(is.null(x), NA, x)))
df.3[nrow(df.3) + 1,] <- NA # optional steps

trait_matrixatgranularity3 = as.data.frame(cbind(df,df.1,df.2,df.3))

# Changing colum names #### 

names = levels(((df_with_special_characters[["trait_counts_atgranularity3"]])[,1]))
colnames(trait_matrixatgranularity3) = c("id",names,"ogt","growthrate_d")

#write.csv(apply(trait_matrixatgranularity3,2,as.character), file = "C:/luciana_datos/UCI/Project_2 (microtrait-dement)/MAG_database/MAG_Loma/trait_matrixatgranularity3_Loma.csv")
#write.csv(apply(trait_matrixatgranularity3,2,as.character), file = "C:/luciana_datos/UCI/Project_2 (microtrait-dement)/MAG_database/MAGs_burnt/trait_matrixatgranularity3_Fire.csv")

# Extracting proteins from rds files ####

# Loop to extract proteins ####

c = list()
d = list()

for (i in 1:length(genomes_files)) {
  df_with_special_characters <- readRDS(genomes_files[i])
  a   = as.data.frame(c(df_with_special_characters[["genes_detected"]],
                        df_with_special_characters[["domains_detected"]]))
  colnames(a) = "protein"
  b   = df_with_special_characters[["id"]]
  c[[i]] = (list(a))
  d[[i]] = (list(b))
}

df.1 = do.call("rbind",d)

# Finding the proteins in all the genomes ####

f      = list()
hmm_key    = read.csv("C:/luciana_datos/UCI/Project_2 (microtrait-dement)/MICROTRAIT_DEMENT/hmm_microtrait.csv",dec=".")

for (i in 1:length(c)){
  test_2 = as.data.frame(c[[i]])
  f[[i]] = t(as.data.frame(hmm_key$microtrait_hmm.name %in% test_2$protein)) # compare with the hmm key
}

df.pro = do.call("rbind",f)

hmm = as.data.frame(cbind(df.1,df.pro))
colnames(hmm) = c("id",hmm_key$microtrait_hmm.name)
rownames(hmm) = 1:nrow(hmm)
hmm[,2:2299]  = as.integer(hmm[,2:2299] == TRUE)
#write.csv(apply(hmm,2,as.character), file = "C:/luciana_datos/UCI/Project_2 (microtrait-dement)/MAG_database/MAG_Loma/hmm_Loma_full.csv")
#write.csv(apply(hmm,2,as.character), file = "C:/luciana_datos/UCI/Project_2 (microtrait-dement)/MAG_database/MAGs_burnt/hmm_Fire_full.csv")
temp.1        = as.data.frame(cbind((colSums(hmm[,2:2299]))))
erase.1       = temp.1 %>% filter(V1==0)
erase.1$row_names = row.names(erase.1)
hmm           = hmm[ , !(names(hmm) %in% erase.1$row_names)]

#write.csv(apply(hmm,2,as.character), file = "C:/luciana_datos/UCI/Project_2 (microtrait-dement)/MAG_database/MAG_Loma/hmm_Loma.csv")
#write.csv(apply(hmm,2,as.character), file = "C:/luciana_datos/UCI/Project_2 (microtrait-dement)/MAG_database/MAGs_burnt/hmm_Fire.csv")




