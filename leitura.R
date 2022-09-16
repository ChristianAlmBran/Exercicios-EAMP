#carrega base de dados
data(mtcars)

#carrega pacotes
pacman::p_load(microbenchmark)
pacman::p_load(readr)

# exporta a base de dados mtcars em formato txt
write_tsv(mtcars, "bases_tratadas/mtcars.txt")

# exporta a base de dados em formato nativo do R
saveRDS(mtcars, "bases_tratadas/mtcars.rds")


# carrega a base de dados em formato nativo R
mtcarsNativo <- readRDS('bases_tratadas/mtcars.rds')

# carrega outra base de dados em formato txt
mtcarsTexto <- read.delim('bases_tratadas/mtcars.txt')

# compara os dois processos de exportaÃ§Ã£o com outras bases de dados, usando a funÃ§Ã£o microbenchmark

microbenchmark(a <- saveRDS(mtcarsNativo, "bases_tratadas/mtcars.rds"), b <- write_tsv(mtcarsTexto, "bases_tratadas/mtcars.txt"), times = 30L)

microbenchmark(a <- readRDS('bases_tratadas/mtcars.rds'), b <- read.delim('bases_tratadas/mtcars.txt'), times = 10L)
