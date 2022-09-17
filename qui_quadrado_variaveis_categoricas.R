# carregar os pacotes
pacman::p_load(data.table, ggplot2)

# baixando a base de dados
breast_cancer <- fread('https://raw.githubusercontent.com/hugoavmedeiros/cp_com_r/master/bases_tratadas/breast_cancer.csv', stringsAsFactors = T)

# tabela de contingencia
breast_cancer_table <- table(breast_cancer$idade, breast_cancer$tumor_tamanho)
breast_cancer_table

# grafico de dispersão
ggplot(breast_cancer) + aes(x = tumor_tamanho, fill = idade) + geom_bar(position = "fill")

# teste Qui Quadrado
breast_cancer_test <- chisq.test(breast_cancer_table)
breast_cancer_test
breast_cancer_test$observed
breast_cancer_test$expected

# corroplot das variaveis
corrplot(breast_cancer_test$residuals, is.cor = FALSE)
