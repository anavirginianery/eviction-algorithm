set.seed(42)
num_requests <- 1000
num_pages <- 100
local_group <- 10 # Número de páginas acessadas com alta frequência em curto prazo

access_list <- c()
for (i in seq(1, num_requests, by = 50)) {
  # Acessar intensivamente um pequeno grupo de páginas
  group_access <- sample(1:local_group, 50, replace = TRUE)
  access_list <- c(access_list, group_access)
}
hist(access_list, breaks = num_pages, main="Acessos com Localidade Temporal")

