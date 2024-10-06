# Instalar pacotes necessários
#install.packages("optparse")
#install.packages("VGAM")
#install.packages("dplyr")
#install.packages("ggplot2")

# Carregar bibliotecas
library(optparse)
library(VGAM)
library(dplyr)
library(ggplot2)

# Definir as opções de linha de comando (flags)
option_list = list(
  make_option(c("-a", "--alpha"), type = "numeric", default = 1.2,
              help = "Parâmetro da distribuição Pareto para popularidade (alpha)", metavar = "numeric"),
  make_option(c("-l", "--lambda"), type = "numeric", default = 5,
              help = "Taxa média de chegada de acessos (lambda) na Poisson", metavar = "numeric"),
  make_option(c("-n", "--num_accesses"), type = "integer", default = 100,
              help = "Número total de acessos", metavar = "integer"),
  make_option(c("-p", "--num_pages"), type = "integer", default = 50,
              help = "Número total de páginas", metavar = "integer"),
  make_option(c("-o", "--output"), type = "character", default = "access_trace.csv",
              help = "Nome do arquivo de saída", metavar = "character"),
  make_option(c("-g", "--graph_output"), type = "character", default = "access_histogram.png",
              help = "Nome do arquivo de gráfico de saída", metavar = "character"),
  make_option(c("-r", "--pareto_ratio"), type = "numeric", default = 0.8,
              help = "Proporção de acessos baseados em Pareto (entre 0 e 1)", metavar = "numeric")
)

# Parsing dos argumentos da linha de comando
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

# Exibir os valores escolhidos
print(paste("alpha:", opt$alpha))
print(paste("lambda:", opt$lambda))
print(paste("num_accesses:", opt$num_accesses))
print(paste("num_pages:", opt$num_pages))
print(paste("Arquivo de saída:", opt$output))
print(paste("Arquivo do gráfico de saída:", opt$graph_output))
print(paste("Proporção de acessos Pareto:", opt$pareto_ratio))

# Parâmetros de geração a partir dos argumentos fornecidos
alpha <- opt$alpha
lambda <- opt$lambda
num_accesses <- opt$num_accesses
num_pages <- opt$num_pages
output_file <- opt$output
graph_output <- opt$graph_output
pareto_ratio <- opt$pareto_ratio

# Gerando a distribuição de Pareto para a popularidade das páginas
pareto <- rpareto(num_pages, scale = 1, shape = alpha)
accesses_per_page <- ceiling(pareto)

# Distribuindo os tempos de acesso com uma distribuição de Poisson
arrival_times <- cumsum(rpois(num_accesses, lambda))

# Calculando a quantidade de acessos baseados em Pareto e acessos aleatórios
num_pareto_accesses <- floor(num_accesses * pareto_ratio)
num_random_accesses <- num_accesses - num_pareto_accesses

# Gerando acessos com alta frequência (baseado em Pareto)
temporal_accesses <- sample(1:num_pages, num_pareto_accesses, replace = TRUE, prob = accesses_per_page)

# Gerando acessos de forma aleatória
random_accesses <- sample(1:num_pages, num_random_accesses, replace = TRUE)

# Combinando os dois padrões de acesso
page_ids <- c(temporal_accesses, random_accesses)

# Criando o dataframe com os acessos e timestamps
access_trace <- data.frame(
  Timestamp = arrival_times,
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
