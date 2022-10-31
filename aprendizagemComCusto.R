pacman::p_load(ade4, arules, car, caret, corrplot, data.table, dplyr, e1071, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

# carregar dados covid19 Bahia
covid19BA <- fread('https://ftp.sei.ba.gov.br/covid19/informacoes_covid_municipios_BA.csv')

covid19BA <- covid19BA[c(1:417)]
# Dummies
COVID19_BA_D <- acm.disjonctif(as.data.frame(covid19BA$NRS))
names(COVID19_BA_D) <- c('Centro_leste', 'Centro_norte', 'Extremo_sul', 'Leste', 'Nordeste', 'Norte', 'Oeste', 'Sudoeste', 'Sul')

covid19BA <- cbind(covid19BA, COVID19_BA_D)

# Discretização
covid19BA$diasUltimoCasoDisc <- discretize(covid19BA$DIAS_ULTIMO_CASO, method = "interval", breaks = 2, labels = c("poucos", "muitos"))

table(covid19BA$diasUltimoCasoDisc)

# Treino e Teste: Pré-processamento
particaoCovid = createDataPartition(covid19BA$DIAS_ULTIMO_CASO, p=.7, list = F) # cria a partição 70-30
treinoCovid = covid19BA[particaoCovid, ] # treino
testeCovid = covid19BA[-particaoCovid, ] # - treino = teste

table(treinoCovid$diasUltimoCasoDisc)

prop.table(table(treinoCovid$diasUltimoCasoDisc))

# Validação Cruzada: Pré-processamento
# Controle de treinamento
train.control <- trainControl(method = "cv", number = 10, verboseIter = T) # controle de treino

matrizCusto <- matrix(c(0,1,1000,0), ncol = 2)
rownames(matrizCusto) <- levels(treinoCovid$diasUltimoCasoDisc)
colnames(matrizCusto) <- levels(treinoCovid$diasUltimoCasoDisc)
matrizCusto

COVID_RF_CLASS <- randomForest(diasUltimoCasoDisc ~ ATIVOS  + POP_MUN + Centro_leste + Centro_norte + Extremo_sul + Leste + Nordeste + Norte + Oeste + Sudoeste + Sul, data = treinoCovid, method = "cforest", parms = list(loss = matrizCusto))
COVID_RF_CLASS

COVID_C5_CLASS <- train(diasUltimoCasoDisc ~ ATIVOS  + POP_MUN + Centro_leste + Centro_norte + Extremo_sul + Leste + Nordeste + Norte + Oeste + Sudoeste + Sul, data = treinoCovid, method = "C5.0Cost", trControl = train.control)
COVID_C5_CLASS

predicaoCOVID_RF_CLASS = predict(COVID_RF_CLASS, testeCovid) # criar predição
cmCOVID_RF_CLASS <- confusionMatrix(predicaoCOVID_RF_CLASS, 
                                  testeCovid$diasUltimoCasoDisc)
cmCOVID_RF_CLASS

predicaoCOVID_C5_CLASS = predict(COVID_C5_CLASS, testeCovid) # criar predição
cmCOVID_C5_CLASS <- confusionMatrix(predicaoCOVID_C5_CLASS, 
                                  testeCovid$diasUltimoCasoDisc)
cmCOVID_C5_CLASS
