# carregar as bibliotecas
pacman::p_load(cluster, dplyr, factoextra, ggplot2)

# pré-processamento
View(USArrests)

# Método do Cotovelo
fviz_nbclust(USArrests, kmeans, method = "wss")

# Agrupamento com kmeans
cls <- kmeans(x = USArrests, centers = 3) # aprendizagem ns
USArrests$cluster <- as.factor(cls$cluster) # passamos os clusters para a base original
head(USArrests)

# plot com função própria do pacote
clusplot(USArrests, cls$cluster, xlab = 'Fator1', ylab = 'Fator2', main = 'Agrupamento Estados', lines = 0, shade = F, color = TRUE, labels = 2)
