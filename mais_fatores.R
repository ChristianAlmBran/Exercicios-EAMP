# obter a base de dados
florestFireAlgeria <- read.csv2('https://archive.ics.uci.edu/ml/machine-learning-databases/00547/Algerian_forest_fires_dataset_UPDATE.csv', sep = ",", skip = 1)

str(florestFireAlgeria)

# carrega pacotes
pacman::p_load(ade4)
pacman::p_load(arules)
pacman::p_load(forcats)
pacman::p_load(tidyverse)

# transformando em fatores
for(i in 4:14) {florestFireAlgeria[,i] <- as.factor(florestFireAlgeria[,i])} 

# filtrando por tipo de dado
factorsFlorestFireAlgeria <- unlist(lapply(florestFireAlgeria, is.factor))  
florestFireAlgeriaFactor <- florestFireAlgeria[ , factorsFlorestFireAlgeria]

str(florestFireAlgeriaFactor)

# One Hot Enconding
florestFireAlgeriaDummy <- acm.disjonctif(florestFireAlgeriaFactor)

# reclassificando os fatores entre o mais comum, 
#o segundo mais comum e os outros
florestFireAlgeriaFrequencia <- florestFireAlgeria
florestFireAlgeriaFrequencia$Temperature <- fct_lump(florestFireAlgeriaFactor$Temperature, n = 2) 

# alterando os labels dos fatores
florestFireAlgeriaFrequencia$Temperature <- recode_factor(florestFireAlgeriaFrequencia$Temperature, "35" = "mais frequente", "31" = "segundo mais frequente", "Other" = "outros")


