# Para o trace access_trace_aleatorio.csv com as diferentes capacidades

go run Belady.go --input ./traces/access_trace_aleatorio.csv --capacity 5 > ./output/output_aleatorio_belady_5.csv
go run Belady.go --input ./traces/access_trace_aleatorio.csv --capacity 10 > ./output/output_aleatorio_belady_10.csv
go run Belady.go --input ./traces/access_trace_aleatorio.csv --capacity 20 > ./output/output_aleatorio_belady_20.csv
go run Belady.go --input ./traces/access_trace_aleatorio.csv --capacity 25 > ./output/output_aleatorio_belady_25.csv
go run Belady.go --input ./traces/access_trace_aleatorio.csv --capacity 40 > ./output/output_aleatorio_belady_40.csv
go run Belady.go --input ./traces/access_trace_aleatorio.csv --capacity 50 > ./output/output_aleatorio_belady_50.csv

# Para o trace access_trace_localidade_temporal.csv com as diferentes capacidades

go run Belady.go --input ./traces/access_trace_localidade.csv --capacity 5 > ./output/output_localidade_belady_5.csv
go run Belady.go --input ./traces/access_trace_localidade.csv --capacity 10 > ./output/output_localidade_belady_10.csv
go run Belady.go --input ./traces/access_trace_localidade.csv --capacity 20 > ./output/output_localidade_belady_20.csv
go run Belady.go --input ./traces/access_trace_localidade.csv --capacity 25 > ./output/output_localidade_belady_25.csv
go run Belady.go --input ./traces/access_trace_localidade.csv --capacity 40 > ./output/output_localidade_belady_40.csv
go run Belady.go --input ./traces/access_trace_localidade.csv --capacity 50 > ./output/output_localidade_belady_50.csv

# Para o trace access_trace_altaFrequencia.csv com as diferentes capacidades

go run Belady.go --input ./traces/access_trace_altaFrequencia.csv --capacity 5 > ./output/output_altaFrequencia_belady_5.csv
go run Belady.go --input ./traces/access_trace_altaFrequencia.csv --capacity 10 > ./output/output_altaFrequencia_belady_10.csv
go run Belady.go --input ./traces/access_trace_altaFrequencia.csv --capacity 20 > ./output/output_altaFrequencia_belady_20.csv
go run Belady.go --input ./traces/access_trace_altaFrequencia.csv --capacity 25 > ./output/output_altaFrequencia_belady_25.csv
go run Belady.go --input ./traces/access_trace_altaFrequencia.csv --capacity 40 > ./output/output_altaFrequencia_belady_40.csv
go run Belady.go --input ./traces/access_trace_altaFrequencia.csv --capacity 50 > ./output/output_altaFrequencia_belady_50.csv
