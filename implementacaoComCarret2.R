# carrega a base
residos <- read.csv2('http://dados.recife.pe.gov.br/dataset/2bc56ecf-4716-449e-9c72-1241f090c6d9/resource/41a65b6d-1e31-4084-9d6b-1f50bfd004e5/download/pesagens2016.csv')

# carrega pacotes 
pacman::p_load(ade4, arules, car, caret, corrplot, data.table, dplyr, e1071, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

# seleciona as colunas de interesse
residos2 <- residos %>%
  select(LOCDESCARREGO_DESC, TPVEICULO_DESC, PES_PESOUTIL, COLETA_DES)


residos_D <- acm.disjonctif(as.data.frame(residos2$LOCDESCARREGO_DESC))
residos_D2 <- acm.disjonctif(as.data.frame(residos2$TPVEICULO_DESC))
residos_D3 <- acm.disjonctif(as.data.frame(residos2$COLETA_DES))

ENEM_ESCOLA_2019 <- cbind(ENEM_ESCOLA_2019, ENEM_ESCOLA_2019_D)

residos3 <- cbind(residos2, residos_D)
residos4 <- cbind(residos3, residos_D2)
residos5 <- cbind(residos4, residos_D3)

## Aprendizagem de maquina

# visualizacao estatistica
status(residos5) 
freq(residos5) 
plot_num(residos5)
profiling_num(residos5)

# Treino e Teste
particaoResidos = createDataPartition(residos5$PES_PESOUTIL, p=.7, list = F)
treinoResidos = residos5[particaoResidos, ] 
testeResidos = residos5[-particaoResidos, ]

# Validação Cruzada
train.control <- trainControl(method = "cv", number = 10, verboseIter = T) 

# Regressão Linear
RESIDOS_LM <- train(PES_PESOUTIL ~ LOCDESCARREGO_DESC +
                   TPVEICULO_DESC + COLETA_DES, data = treinoResidos,
                   method = "lm", trControl = train.control)
summary(RESIDOS_LM) 
plot(varImp(RESIDOS_LM))

# arvore de decisao
RESIDOS_RPART <- train(PES_PESOUTIL ~ LOCDESCARREGO_DESC + TPVEICULO_DESC +
                       COLETA_DES, data = treinoResidos, method = "rpart", 
                       trControl = train.control)
summary(RESIDOS_RPART)
fancyRpartPlot(RESIDOS_RPART$finalModel) 
plot(varImp(RESIDOS_RPART)) 

# Bagging com Floresta Aleatoria
RESIDOS_RF <- train(PES_PESOUTIL ~ LOCDESCARREGO_DESC + TPVEICULO_DESC +
                    COLETA_DES, data = treinoResidos, method = "cforest", 
                    trControl = train.control)

plot(RESIDOS_RF) 
plot(varImp(RESIDOS_RF)) 

# Boosting com Boosted Generalized Linear Model
RESIDOS_ADA <- train(PES_PESOUTIL ~ LOCDESCARREGO_DESC + TPVEICULO_DESC +
                     COLETA_DES, data = treinoResidos, method = "glmboost", 
                     trControl = train.control)

plot(RESIDOS_ADA) 
print(RESIDOS_ADA) 
summary(RESIDOS_ADA) 

melhor_modelo <- resamples(list(LM = RESIDOS_LM, RPART = RESIDOS_RPART, RF = RESIDOS_RF, ADABOOST = RESIDOS_ADA))
melhor_modelo

summary(melhor_modelo)

predVals <- extractPrediction(list(RESIDOS_RF), testX = testeResudis[, c(3:5)], testY = testeResidos$PES_PESOUTIL) 

plotObsVsPred(predVals)