# Carregar bibliotecas
library(optparse)
library(dplyr)
library(ggplot2)

# Definir as opções de linha de comando (flags)
option_list = list(
  make_option(c("-n", "--num_accesses"), type = "integer", default = 100,
              help = "Número total de acessos", metavar = "integer"),
  make_option(c("-p", "--num_pages"), type = "integer", default = 50,
              help = "Número total de páginas", metavar = "integer"),
  make_option(c("-f", "--num_high_freq_pages"), type = "integer", default = 5,
              help = "Número de páginas de alta frequência", metavar = "integer"),
  make_option(c("-r", "--high_freq_ratio"), type = "numeric", default = 0.6,
              help = "Proporção de acessos das páginas de alta frequência (entre 0 e 1)", metavar = "numeric"),
  make_option(c("-o", "--output"), type = "character", default = "access_trace.csv",
              help = "Nome do arquivo de saída", metavar = "character"),
  make_option(c("-g", "--graph_output"), type = "character", default = "access_histogram.png",
              help = "Nome do arquivo de gráfico de saída", metavar = "character")
)

# Parsing dos argumentos da linha de comando
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

# Exibir os valores escolhidos
print(paste("Número de acessos:", opt$num_accesses))
print(paste("Número de páginas:", opt$num_pages))
print(paste("Número de páginas de alta frequência:", opt$num_high_freq_pages))
print(paste("Proporção de acessos das páginas de alta frequência:", opt$high_freq_ratio))
print(paste("Arquivo de saída:", opt$output))
print(paste("Arquivo do gráfico de saída:", opt$graph_output))

# Parâmetros de geração a partir dos argumentos fornecidos
num_accesses <- opt$num_accesses
num_pages <- opt$num_pages
num_high_freq_pages <- opt$num_high_freq_pages
high_freq_ratio <- opt$high_freq_ratio
output_file <- opt$output
graph_output <- opt$graph_output

# Verificar se o número de acessos de alta frequência não ultrapassa o total de acessos
num_high_freq_accesses <- floor(num_accesses * high_freq_ratio)
num_random_accesses <- num_accesses - num_high_freq_accesses

# Gerar páginas de alta frequência e garantir que o número de páginas seja adequado
high_freq_pages <- sample(1:num_pages, num_high_freq_pages, replace = FALSE)
random_pages <- setdiff(1:num_pages, high_freq_pages)

# Gerar acessos de alta frequência e aleatórios
high_freq_accesses <- sample(high_freq_pages, num_high_freq_accesses, replace = TRUE)
random_accesses <- sample(random_pages, num_random_accesses, replace = TRUE)

# Intercalando acessos de alta frequência e aleatórios
page_ids <- c()
for (i in 1:max(length(high_freq_accesses), length(random_accesses))) {
  if (i <= length(high_freq_accesses)) {
    page_ids <- c(page_ids, high_freq_accesses[i])
  }
  if (i <= length(random_accesses)) {
    page_ids <- c(page_ids, random_accesses[i])
  }
}

# Verificar se o comprimento dos ids gerados é correto
page_ids <- page_ids[1:num_accesses]

# Criar os timestamps sequenciais
timestamps <- 1:num_accesses

# Criar o dataframe com os acessos e timestamps
access_trace <- data.frame(
  Timestamp = timestamps,
  PageID = page_ids
)

# Salvando o resultado em um arquivo CSV
write.csv(access_trace, file = output_file, row.names = FALSE)

cat("Arquivo gerado:", output_file, "\n")

# Salvar o histograma como um arquivo PNG
png(graph_output, width = 800, height = 600)
ggplot(access_trace, aes(x = PageID)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Distribuição de Acessos às Páginas",
       x = "ID da Página",
       y = "Frequência de Acessos") +
  theme_minimal()
dev.off()

cat("Gráfico salvo em:", graph_output, "\n")
