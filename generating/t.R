set.seed(42)  # Definir uma seed para reprodutibilidade

# Parâmetros
num_pages <- 100          # Número de páginas
mean_accesses <- 50       # Média de acessos por página
sd_accesses <- 10         # Desvio padrão dos acessos

# Gerar número de acessos por página usando uma distribuição normal
accesses_per_page <- round(rnorm(num_pages, mean = mean_accesses, sd = sd_accesses))

# Garantir que o número de acessos não seja menor que 1
accesses_per_page <- ifelse(accesses_per_page < 1, 1, accesses_per_page)

# Exibir distribuição dos acessos por página
accesses_per_page

# Exibir histograma para visualização
hist(accesses_per_page, main="Distribuição dos Acessos por Página", xlab="Número de Acessos")

