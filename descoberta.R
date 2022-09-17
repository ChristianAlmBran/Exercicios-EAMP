# carrega os pacotes
pacman::p_load(funModeling, tidyverse) 

# olhada nos dados
glimpse(mtcars) # olhada nos dados

# estrutura dos dados
status(mtcars) # estrutura dos dados 

# transformando a variavel carb em factor e frequência das variáveis fator
mtcars2 <- as.factor(mtcars$carb)
freq(mtcars2) 

# exploração das variáveis numéricas
plot_num(mtcars) 

# estatísticas das variáveis numéricas
profiling_num(mtcars) # estatísticas das variáveis numéricas
