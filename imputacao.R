# carrega os pacotes
pacman::p_load(data.table, Hmisc, VIM) 

## imputação numérica
# tendência central
airquality2 <- impute(airquality, fun = mean) # média
is.imputed(airquality2) # teste se o valor foi imputado
table(is.imputed(airquality2)) # tabela de imputação por sim / não


## Hot deck
# imputação por instâncias /semelhança
airquality3 <- kNN(airquality)
