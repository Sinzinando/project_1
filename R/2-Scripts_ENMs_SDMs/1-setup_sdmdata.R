###################################
# Script setup sdm_data
# R version 4.1 .1
# modler version 0.0.1
###################################

## Carregague as bibliotecas instaladas 

library(sp)
library(modleR)
library(raster)

# Ao criar um projeto no Rstudio (e neste exemplo integrado ao Git e Github), o R já entende qual é o diretório de trabalho, ou seja, não é preciso informar o caminho completo (absoluto). Além disso, caminhos absolutos em geral são uma má prática, pois deixam o código irreprodutível, ou seja, se você trocar de computador ou passar o script para outra pessoa rodar, o código não vai funcionar, pois o caminho absoluto geralmente está em um computador específico com uma estrutura de pasta (caminhos) pessoal.

# Uma boa prática é optar, sempre que possível, trabalhar com projetos no RStudio, dessa forma voce pode usar os caminhos relativos, que são aqueles que tem início no diretório de trabalho da sua sessão. Isso nos incentiva a colocar todos os arquivos da análise dentro da pasta do projeto. Assim, se você usar apenas caminhos relativos e compartilhar a pasta do projeto com alguém (por exemplo via github), todos os caminhos existentes nos códigos continuarão a funcionar em qualquer computador! No exemplo da nossa prática, trabalharemos dessa forma, e para isso vamos inicar o caminho relativo sempre com "./" (mas tem outras formas). 

### Importando e lendo sua planilha no ambiente R. read.csv é uma função para ler a extensão .csv. NO argumento "file" coloque o caminho relativo do arquivo .csv , no arquivo "sep" indique qual o tipo de separado dos campos (o que separa as colunas).

sp_input <- read.csv(file = "./dados/ocorrencias/sp_input_setupsdmdata.csv", sep = ",") 

## Colocando no formato exigido pelo pacote: species name separated by "_" 
sp_input$species <-
  gsub(x = sp_input$species,
       pattern = " ",
       replacement = "_") 


## Carregando as variáveis ambientais

lista_arquivos <- list.files("./dados/raster/variaveis_cortadas_pratica/", full.names = T, pattern = ".tif")

vars_stack <-stack(lista_arquivos)
plot(vars_stack[[12]])

## Verificando os pontos nas variáveis mais um vez. Isso pode ser feito previamente no Qgis. Em termos de verificação de pontos, ou verificar valores de pixel de forma mais rápida, o Qgis pode ser mais apropriado. 
## Talvez não seja possível gerar a imagem e código abaixo não funcione a cuse um erro. Por isso é aconselhável que seja feita a verificação dos pontos em cimas das camadas ambientais no Qgis.

par(mfrow = c(1, 1), mar = c(2, 2, 3, 1))
for (i in 1:length(sp_input)) {
  plot(!is.na(vars_stack[[1]]),
       legend = FALSE,
       col = c("white", "#00A08A"))
  points(lat ~ lon, data = sp_input, pch = 19)
}

## modler função 1

setup_sdmdata_1 <- setup_sdmdata(species_name = unique(sp_input[1]), 
                                 occurrences = sp_input,
                                 lon = "lon",
                                 lat = "lat",
                                 predictors = vars_stack,
                                 models_dir = "./resultados",
                                 partition_type = "crossvalidation",
                                 cv_partitions = 3,
                                 cv_n = 1,
                                 seed = 512,
                                 buffer_type = "mean",
                                 png_sdmdata = TRUE,
                                 n_back = 30,
                                 clean_dupl = TRUE,
                                 clean_uni = TRUE,
                                 clean_nas = TRUE,
                                 #geo_filt = FALSE,
                                 #geo_filt_dist = 0,
                                 select_variables = TRUE,
                                 sample_proportion = 0.5,
                                 cutoff = 0.7)
