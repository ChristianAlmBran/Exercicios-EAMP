pacman::p_load(tidyverse, rsample, dplyr, ggplot2, rpart, rpart.plot, caret, ade4, car, caret, corrplot, data.table, dplyr, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

view(mpg)

mpg2 <- mpg %>%
  select( cyl, hwy, displ, class)

# Treino e Teste: Pré-processamento
particaoMpg2 = createDataPartition(mpg2$hwy, p=.7, list = F) # cria a partição 70-30
treinoMpg2 = mpg2[particaoMpg2, ] # treino
testeMpg2 = mpg2[-particaoMpg2, ] # - treino = teste

# Validação Cruzada: Pré-processamento
# Controle de treinamento
train.control <- trainControl(method = "cv", number = 10, verboseIter = T)

# Treinamentos
## Regressão Linear
MPG_LM <- train(hwy ~ cyl + displ + class, data = train,, method = "lm", trControl = train.control)
summary(MPG_LM) # sumário do modelo linear
plot(varImp(MPG_LM))

## Árvore de Decisão
MPG_RPART <- train(hwy ~ cyl + displ + class, data = train, method = "rpart", trControl = train.control)

summary(CAR_RPART)
fancyRpartPlot(CAR_RPART$finalModel) # desenho da árvore
plot(varImp(CAR_RPART)) # importância das variáveis

# Bagging com Floresta Aleatória
MPG_RF <- train(hwy ~ cyl + displ + class, data = train, method = "cforest", trControl = train.control)

plot(MPG_RF) # evolução do modelo
plot(varImp(MPG_RF)) # plot de importância

# Boosting com Boosted Generalized Linear Model
MPG_ADA <- train(hwy ~ cyl + displ + class, data = train, method = "glmboost", trControl = train.control)

plot(MPG_ADA) # evolução do modelo
print(MPG_ADA) # modelo
summary(MPG_ADA) # sumário

melhor_modelo <- resamples(list(LM = MPG_LM, RPART = MPG_RPART, RF = MPG_RF, ADABOOST = MPG_ADA))
melhor_modelo

summary(melhor_modelo)

predVals <- extractPrediction(list(MPG_RF), testX = testeMpg2[, c(1,3,4)], testY = testeMpg2$hwy) 

plotObsVsPred(predVals)
