import json
import subprocess
import time
import csv
import os

def run_simulation(algorithm, memory_size, trace_file, output_file):
	build_result = subprocess.run(["make", "build"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

	if build_result.returncode != 0:
		print(f"Erro ao construir o projeto.")
		print(build_result.stderr.decode("utf-8"))
		return None

	with open(output_file, 'w') as outfile:
		start_time = time.time()
		result = subprocess.run(
			[
				"./memory_simulator",
				"--eviction_algo", algorithm,
				"--memory_size", str(memory_size)
			],
			input=open(trace_file, 'rb').read(),
			stdout=outfile,
			stderr=subprocess.PIPE
		)
		execution_time = time.time() - start_time

	if result.returncode != 0:
		print(f"Erro ao executar a simulação com {algorithm}, {memory_size}, {trace_file}")
		print(result.stderr.decode("utf-8"))
		return None
	
	return execution_time

with open('./scripts/config.json') as config_file:
	config = json.load(config_file)

algorithms = config["algorithms"]
capacities = config["capacities"]
traces = config["traces"]

output_file = "simulation_results.csv"

with open(output_file, mode='w', newline='') as file:
	writer = csv.writer(file)
	writer.writerow(["Algorithm", "Memory Size", "Trace File", "Execution Time (s)", "Output File"])

	for algorithm in algorithms:
		for capacity in capacities:
			for trace in traces:
				trace_name = os.path.basename(trace).replace(".csv", "")
				trace_name_selected = trace_name.split("_")[2]
				output_simulation_file = f"./output/output_{trace_name_selected}_{algorithm}_{capacity}.csv"
				
				print(f"Running simulation: Algorithm={algorithm}, Memory Size={capacity}, Trace={trace}, Output={output_simulation_file}")
				
				execution_time = run_simulation(algorithm, capacity, trace, output_simulation_file)
				
				if execution_time is not None:
					writer.writerow([algorithm, capacity, trace, execution_time, output_simulation_file])

print(f"Simulations completed. Results saved to {output_file}")
