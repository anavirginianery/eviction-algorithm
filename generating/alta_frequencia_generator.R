library(optparse)

generate_high_frequency_load <- function(mean_page, sd_page, num_accesses, num_pages, output_file) {
  page_accesses <- round(rnorm(num_accesses, mean = mean_page, sd = sd_page))
  
  page_accesses <- ifelse(page_accesses < 1, 1, page_accesses)  # Limite inferior
  page_accesses <- ifelse(page_accesses > num_pages, num_pages, page_accesses)  # Limite superior
  
  arrival_times <- cumsum(rpois(num_accesses, lambda = 10))
  
  access_trace <- data.frame(
    Timestamp = arrival_times,
    PageID = page_accesses
  )
  
  write.csv(access_trace, file = output_file, row.names = FALSE)
  
  cat("Arquivo gerado:", output_file, "\n")
}

# Definir opções de linha de comando (flags)
option_list = list(
  make_option(c("-m", "--mean_page"), type = "numeric", default = 50,
              help = "Média da página mais acessada", metavar = "numeric"),
  make_option(c("-s", "--sd_page"), type = "numeric", default = 5,
              help = "Desvio padrão para dispersão dos acessos", metavar = "numeric"),
  make_option(c("-n", "--num_accesses"), type = "integer", default = 1000,
              help = "Número total de acessos", metavar = "integer"),
  make_option(c("-p", "--num_pages"), type = "integer", default = 100,
              help = "Número total de páginas", metavar = "integer"),
  make_option(c("-o", "--output"), type = "character", default = "high_freq_load.csv",
              help = "Nome do arquivo de saída", metavar = "character")
)

opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

generate_high_frequency_load(opt$mean_page, opt$sd_page, opt$num_accesses, opt$num_pages, opt$output)

