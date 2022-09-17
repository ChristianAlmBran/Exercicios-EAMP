pacman::p_load(data.table, dplyr, tidyverse, validate)

cicloviasDomingosFeriados <- read.csv2('http://dados.recife.pe.gov.br/dataset/667cb4cf-fc93-4687-bb8f-431550eeb2db/resource/2d6d1a15-c8dd-4309-861e-700a0c7d5671/download/rotasoperacionaisciclovias-jul21.csv')

cicloviasDomingosFeriados$extensao <- cicloviasDomingosFeriados$extensao %>%
  as.numeric()

cicloviasDomingosFeriados$extensao %>%
  typeof()

regras_cicloviasDomingosFeriados <- validator(extensao >= 0, inauguracao >= 2000)

validacao_cicloviasDomingosFeriados <- confront(cicloviasDomingosFeriados, regras_cicloviasDomingosFeriados)

summary(validacao_cicloviasDomingosFeriados)

plot(validacao_cicloviasDomingosFeriados)
