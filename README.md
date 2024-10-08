# Algoritmos de Eviction

## Setup

### Como rodar os algoritmos

Para compilar o projeto, execute o seguinte comando:

```bash
make build
```

## Simulação

Para rodar uma simulação, utilize o seguinte comando:

```bash
./memory_simulator -memory_size=10 -eviction_algo=2Lists < trace_localidade_temporal.csv >> output/localidade
```

Este comando roda uma simulação do algoritmo 2Lists com um tamanho de memória de 10 páginas usando o trace trace_localidade_temporal.csv. O resultado será redirecionado para o arquivo output/localidade.

## Cálculo do Hit Ratio

Para calcular o Hit Ratio das simulações realizadas, o input deve ser um diretório contendo arquivos de saída das simulações. Estes arquivos devem seguir o formato output_{trace}_{algoritmo}_{capacidade}.

Execute o seguinte comando para obter o Hit Ratio:

```bash
./hitRatio_dir <path-do-diretório>
```

O comando irá retornar o hit ratio para cada simulação no formato:

```
policy,capacity,hitRatio
```

## Experimentos

No diretório scripts, há um script para simular diversas configurações que podem ser indicadas no arquivo config.json. O arquivo config.json especifica os algoritmos, capacidades e traces, e o script fará a combinação dos três componentes para rodar os experimentos.

Para rodar o script, execute o seguinte comando:

```bash
python3 scripts/experiment.py
```

O script retornará um arquivo contendo as simulações realizadas, o tempo de execução de cada uma e os arquivos de saída correspondentes.

# Geradores de Cargas de Trabalho

## Setup

Para instalar os pacotes necessários para a geração das cargas de trabalho, execute os seguintes comandos no terminal:

```bash
R -e "install.packages('optparse')"
R -e "install.packages('VGAM')"
R -e "install.packages('dplyr')"
R -e "install.packages('ggplot2')"
```

## Como gerar cargas de trabalho

### Acessos com Páginas de Alta Frequência

Para gerar uma carga de trabalho com acessos de páginas de alta frequência, execute o seguinte comando:

```bash
Rscript alta_frequencia_generator.R --num_accesses 1000 --num_pages 50 --num_high_freq_pages 10 --high_freq_ratio 0.75 --output "access_trace_alta_frequencia.csv" --graph_output "access_histogram_alta_frequencia.png"
```

### Acessos com Localidade Temporal

Para gerar uma carga de trabalho com alta localidade temporal, utilizando uma distribuição de Pareto para popularidade e distribuição de Poisson para intervalos de tempo, execute o seguinte comando:

```bash
Rscript localidade_temporal_generator.R --alpha 1.2 --lambda 8 --num_accesses 1000 --num_pages 50 --pareto_ratio 0.9 --output "access_trace_localidade_temporal.csv" --graph_output "access_histogram_localidade_temporal.png"
```

Esses geradores de carga permitem configurar:

- Número total de acessos: quantidade de acessos simulados.
- Número total de páginas: quantidade de páginas únicas que podem ser acessadas.
- Proporção de acessos de alta frequência ou localidade temporal: nas cargas de alta frequência, controla a porcentagem de acessos concentrados em poucas páginas.
- Parâmetro alpha: na distribuição de Pareto, afeta a concentração dos acessos nas páginas mais populares.
- Parâmetro lambda: controla o intervalo médio entre os acessos na distribuição de Poisson.

### Acessos com aleatoriedade

Para gerar uma carga aleatória (sem alta frequência ou localidade temporal), utilize o seguinte comando:

```bash
Rscript alta_frequencia_generator.R --num_accesses 1000 --num_pages 50 --high_freq_page 0 --high_freq_ratio 0.0 --output "access_trace_aleatorio.csv" --graph_output "access_histogram_aleatorio.png"
```