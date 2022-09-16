#### Staging area e uso de memória

# carrega pacotes
pacman::p_load(tidyverse)

#base de dados e modificações
# carrega a base de snistros de transito do site da PCR
sinistrosRecife2020Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/fc1c8460-0406-4fff-b51a-e79205d1f1ab/download/acidentes_2020-novo.csv', sep = ';', encoding = 'UTF-8')

sinistrosRecife2021Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2021-jan.csv', sep = ';', encoding = 'UTF-8')

# junta as bases de dados com comando rbind (juntas por linhas)
colunas_iguais <- names(sinistrosRecife2020Raw[
  intersect(
    names(sinistrosRecife2020Raw), names(sinistrosRecife2021Raw))])

sinistrosRecife2020Raw <- sinistrosRecife2020Raw %>% select(all_of(colunas_iguais))

sinistrosRecifeRaw <- rbind(sinistrosRecife2020Raw, sinistrosRecife2021Raw)

# vamos ver quanto cada objeto está ocupando e criando a função
#naZero

for (itm in ls()) { 
  print(formatC(c(itm, object.size(get(itm))), 
                format="d", 
                width=30), 
        quote=F)
}

# sinistrosRecifeRaw é o objeto que está ocupando mais memoria

naZero <- function(x) {
  x <- ifelse(is.na(x), 0, x)
}

ls() # lista todos os objetos no R

# agora, vamos remover deixando apenas sisnistrosRecifeRaw e na Zero

rm(list = c('sinistrosRecife2020Raw', 'sinistrosRecife2021Raw', 'colunas_iguais', 'itm'))

ls()

saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")

write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")
