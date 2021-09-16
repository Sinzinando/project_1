###################################
# Script do_any_do_many
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

### Rodando a função do_any para um algoritmo (Maxent)

sp_maxent <- do_any(species_name = unique(sp_input[1]),
                    algorithm = "maxnet",
                    #proj_model= TRUE
                    #proj_data_folder = "./dados/raster/proj"
                    predictors = vars_stack,
                    models_dir = "./resultados",
                    png_partitions = TRUE,
                    write_bin_cut = FALSE,
                    equalize = FALSE,
                    write_rda = FALSE)

### Rodando a função do_amay para mais de um algoritmo (Maxent)

many <- do_many(species_name = unique(sp_input[1]),
                predictors = vars_stack,
                models_dir = "./resultados",
                png_partitions = TRUE,
                write_bin_cut = FALSE,
                write_rda = TRUE,
                bioclim = TRUE,
                domain = FALSE,
                glm = TRUE,
                svmk = FALSE,
                svme = FALSE,
                maxent = FALSE,
                maxnet = FALSE,
                rf = FALSE,
                mahal = FALSE,
                brt = FALSE,
                #proj_data_folder = "./dados/raster/proj"
                equalize = TRUE)



