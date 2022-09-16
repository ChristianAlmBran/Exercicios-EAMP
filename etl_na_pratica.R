pacman::p_load(dplyr)
pacman::p_load(readr)

# carrega a base de sinistros de transito do site da PCR
sinistrosRecife2019Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/3531bafe-d47d-415e-b154-a881081ac76c/download/acidentes-2019.csv', sep = ';', encoding = 'UTF-8')

sinistrosRecife2020Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/fc1c8460-0406-4fff-b51a-e79205d1f1ab/download/acidentes_2020-novo.csv', sep = ';', encoding = 'UTF-8')

sinistrosRecife2021Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2021-jan.csv', sep = ';', encoding = 'UTF-8') 

# transformando a coluna DATA do base de dados do ano 2019
names(sinistrosRecife2019Raw)[names(sinistrosRecife2019Raw) == 'DATA'] <- 'data'

# junta as bases de dados com comando rbind (juntas por linhas)
colunas_iguais <- names(sinistrosRecife2020Raw[
  intersect(
    names(sinistrosRecife2020Raw), names(sinistrosRecife2021Raw))])

sinistrosRecife2020Raw <- sinistrosRecife2020Raw %>% select(all_of(colunas_iguais))

sinistrosRecifeRaw <- rbind(sinistrosRecife2020Raw, sinistrosRecife2021Raw)

colunas_iguais_2 <- names(sinistrosRecifeRaw[
  intersect(
    names(sinistrosRecifeRaw), names(sinistrosRecife2019Raw))])

sinistrosRecife2019Raw <- sinistrosRecife2019Raw %>% select(all_of(colunas_iguais))

sinistrosRecifeRaw_2 <- rbind(sinistrosRecife2019Raw, sinistrosRecifeRaw)

# observa a estrutura dos dados
str(sinistrosRecifeRaw_2)

# modifca a data para formato date
sinistrosRecifeRaw_2$data <- as.Date(sinistrosRecifeRaw_2$data, format = "%Y-%m-%d")

# modifica natureza do sinistro de texto para fator
sinistrosRecifeRaw_2$natureza_acidente <- as.factor(sinistrosRecifeRaw_2$natureza_acidente)

#modifica condiÃ§Ã£o da via de texto para fator
sinistrosRecifeRaw_2$condicao_via <- as.factor(sinistrosRecifeRaw_2$condicao_via)

# cria funÃ§aÃµ para substituir not available (na) por 0
naZero <- function(x) {
  x <- ifelse(is.na(x), 0, x)
}

# aplica a funÃ§Ã£o naZero a todas as colunas de contagem
sinistrosRecifeRaw[, 15:25] <- sapply(sinistrosRecifeRaw[, 15:25], naZero)

# exporta em formato nativo do R
saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")

# exporta em formato tabular (.csv) - padrÃ£o para interoperabilidade
write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")
