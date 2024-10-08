library(optparse)
library(dplyr)

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

)

opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

print(paste("Número de acessos:", opt$num_accesses))
print(paste("Número de páginas:", opt$num_pages))
print(paste("Número de páginas de alta frequência:", opt$num_high_freq_pages))
print(paste("Proporção de acessos das páginas de alta frequência:", opt$high_freq_ratio))
print(paste("Arquivo de saída:", opt$output))

num_accesses <- opt$num_accesses
num_pages <- opt$num_pages
num_high_freq_pages <- opt$num_high_freq_pages
high_freq_ratio <- opt$high_freq_ratio
output_file <- opt$output

num_high_freq_accesses <- floor(num_accesses * high_freq_ratio)
num_random_accesses <- num_accesses - num_high_freq_accesses

high_freq_pages <- sample(1:num_pages, num_high_freq_pages, replace = FALSE)
random_pages <- setdiff(1:num_pages, high_freq_pages)

high_freq_accesses <- sample(high_freq_pages, num_high_freq_accesses, replace = TRUE)
random_accesses <- sample(random_pages, num_random_accesses, replace = TRUE)

page_ids <- c()
for (i in 1:max(length(high_freq_accesses), length(random_accesses))) {
  if (i <= length(high_freq_accesses)) {
    page_ids <- c(page_ids, high_freq_accesses[i])
  }
  if (i <= length(random_accesses)) {
    page_ids <- c(page_ids, random_accesses[i])
  }
}

page_ids <- page_ids[1:num_accesses]

timestamps <- 1:num_accesses

access_trace <- data.frame(
  Timestamp = timestamps,
  PageID = page_ids
)

write.csv(access_trace, file = output_file, row.names = FALSE)

cat("Arquivo gerado:", output_file, "\n")
