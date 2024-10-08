library(optparse)
library(VGAM)
library(dplyr)

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

opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

print(paste("alpha:", opt$alpha))
print(paste("lambda:", opt$lambda))
print(paste("num_accesses:", opt$num_accesses))
print(paste("num_pages:", opt$num_pages))
print(paste("Arquivo de saída:", opt$output))
print(paste("Arquivo do gráfico de saída:", opt$graph_output))
print(paste("Proporção de acessos Pareto:", opt$pareto_ratio))

alpha <- opt$alpha
lambda <- opt$lambda
num_accesses <- opt$num_accesses
num_pages <- opt$num_pages
output_file <- opt$output
graph_output <- opt$graph_output
pareto_ratio <- opt$pareto_ratio

pareto <- rpareto(num_pages, scale = 1, shape = alpha)
accesses_per_page <- ceiling(pareto)

arrival_times <- cumsum(rpois(num_accesses, lambda))

num_pareto_accesses <- floor(num_accesses * pareto_ratio)
num_random_accesses <- num_accesses - num_pareto_accesses

temporal_accesses <- sample(1:num_pages, num_pareto_accesses, replace = TRUE, prob = accesses_per_page)

random_accesses <- sample(1:num_pages, num_random_accesses, replace = TRUE)

page_ids <- c(temporal_accesses, random_accesses)

access_trace <- data.frame(
  Timestamp = arrival_times,
  PageID = page_ids
)

write.csv(access_trace, file = output_file, row.names = FALSE)

cat("Arquivo gerado:", output_file, "\n")
