# carregando pacotes
pacman::p_load(data.table, funModeling, tidyverse) 

## identificando e removendo valores ausentes
status(airquality) # estrutura dos dados (missing etc)

## estimando se o NA é MCAR, MAR ou MANR
# shadow matrix 
airqualityPENA <- as.data.frame(abs(is.na(airquality))) 

# mantém apenas as variáveis com NA
airqualityPENA <- airqualityPENA[which(sapply(airqualityPENA, sd) > 0)] 

# calcula correlações
round(cor(airqualityPENA), 3) 

# busca padrões entre os valores específicos das variáveis e os NA
cor(airquality, airqualityPENA, use="pairwise.complete.obs")
