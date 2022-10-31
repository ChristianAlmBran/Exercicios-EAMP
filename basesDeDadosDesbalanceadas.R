pacman::p_load(ade4, arules, car, caret, corrplot, data.table, dplyr, e1071, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

# carregar dados covid19 Bahia
covid19BA <- fread('https://ftp.sei.ba.gov.br/covid19/informacoes_covid_municipios_BA.csv')

covid19BA <- covid19BA[c(1:417)]
# Dummies
COVID19_BA_D <- acm.disjonctif(as.data.frame(covid19BA$NRS))
names(COVID19_BA_D) <- c('Centro-leste', 'Centro-norte', 'Extremo-sul', 'Leste', 'Nordeste', 'Norte', 'Oeste', 'Sudoeste', 'Sul')

covid19BA <- cbind(covid19BA, COVID19_BA_D)

# Discretização
covid19BA$diasUltimoCasoDisc <- discretize(covid19BA$DIAS_ULTIMO_CASO, method = "interval", breaks = 2, labels = c("baixa", "alta"))

table(covid19BA$diasUltimoCasoDisc)

# Treino e Teste: Pré-processamento
particaoCovid = createDataPartition(covid19BA$DIAS_ULTIMO_CASO, p=.7, list = F) # cria a partição 70-30
treinoCovid = covid19BA[particaoCovid, ] # treino
testeCovid = covid19BA[-particaoCovid, ] # - treino = teste

table(treinoCovid$diasUltimoCasoDisc)

# up
treinoCovidUs <- upSample(x = treinoCovid, y = treinoCovid$diasUltimoCasoDisc)
table(treinoCovidUs$Class) 

 
