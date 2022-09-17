# carregar os pacotes
pacman::p_load(corrplot, dplyr, ggplot2)

# tabela de correcao
cor(USArrests)

# grafico de dispersão
pairs(USArrests)

# corplot das variaveis 
USArrests2 <- cor(USArrests)
corrplot(USArrests2, method = "number", order = 'alphabet')
corrplot(USArrests2, order = 'alphabet') 
