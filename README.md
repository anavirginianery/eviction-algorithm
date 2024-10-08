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

Este gerador permite configurar páginas com alta frequência e gerar uma carga mista, onde páginas de alta frequência são intercaladas com acessos aleatórios.

Parâmetros:

--num_accesses: Número total de acessos a serem simulados.

--num_pages: Número total de páginas que podem ser acessadas.

--num_high_freq_pages: Número de páginas que serão acessadas com alta frequência.

--high_freq_ratio: Proporção dos acessos que se concentram nas páginas de alta frequência.

Para gerar uma carga de trabalho com acessos de páginas de alta frequência, execute o seguinte comando:

```bash
Rscript alta_frequencia_generator.R --num_accesses 1000 --num_pages 50 --num_high_freq_pages 10 --high_freq_ratio 0.75 --output "access_trace_alta_frequencia.csv"
```

### Acessos com Localidade Temporal

Este gerador utiliza uma distribuição de Pareto para gerar popularidade das páginas (localidade temporal) e uma distribuição de Poisson para gerar os tempos de chegada dos acessos.

Parâmetros:

--alpha: Parâmetro da distribuição Pareto, controlando a concentração de acessos nas páginas mais populares.

--lambda: Taxa de chegada de acessos, controlando o intervalo médio de acessos na distribuição Poisson.

--pareto_ratio: Proporção dos acessos baseada na distribuição Pareto.

Para gerar uma carga de trabalho com alta localidade temporal, execute o seguinte comando:

```bash
Rscript localidade_temporal_generator.R --alpha 1.2 --lambda 8 --num_accesses 1000 --num_pages 50 --pareto_ratio 0.9 --output "access_trace_localidade_temporal.csv"
```

### Rodando cargas de trabalho aleatórias

Para gerar uma carga aleatória (sem alta frequência ou localidade temporal), utilize o seguinte comando:

```bash
Rscript alta_frequencia_generator.R --num_accesses 1000 --num_pages 50 --high_freq_page 0 --high_freq_ratio 0.0 --output "access_trace_aleatorio.csv"
```
