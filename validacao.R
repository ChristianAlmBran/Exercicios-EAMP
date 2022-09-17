# carrega pacotes
pacman::p_load(data.table, dplyr, tidyverse, validate)

# baixa a base de dados
cicloviasDomingosFeriados <- read.csv2('http://dados.recife.pe.gov.br/dataset/667cb4cf-fc93-4687-bb8f-431550eeb2db/resource/2d6d1a15-c8dd-4309-861e-700a0c7d5671/download/rotasoperacionaisciclovias-jul21.csv')

# transforma a variavel extensao de text para numeric
cicloviasDomingosFeriados$extensao <- cicloviasDomingosFeriados$extensao %>%
  as.numeric()

# verifica se a conversao foi feita
cicloviasDomingosFeriados$extensao %>%
  typeof()

# cria as regras da validacao
regras_cicloviasDomingosFeriados <- validator(extensao >= 0, inauguracao >= 2000)

# gera a validacao
validacao_cicloviasDomingosFeriados <- confront(cicloviasDomingosFeriados, regras_cicloviasDomingosFeriados)

# analise da validacao
summary(validacao_cicloviasDomingosFeriados)

plot(validacao_cicloviasDomingosFeriados)
