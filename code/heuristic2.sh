#!/bin/bash

# List of input files
input_files=("ocs_1.txt" "ocs_2.txt" "ocs_3.txt" "ocs_4.txt" "ocs_5.txt" "ocs_6.txt" "ocs_7.txt" "ocs_8.txt" "ocs_9.txt" "ocs_10.txt")

#INITIAL TEMP
# Parameters for the heuristic
initial_temp=1000
cooling_rate=0.80
max_iterations=100

# Convert cooling rate to integer percentage
cooling_rate_percent=$(printf "%.0f" $(echo "$cooling_rate * 100" | bc))

# Create a directory based on the parameters
output_dir="resultado_T${initial_temp}_CR${cooling_rate_percent}_MI${max_iterations}"
mkdir -p "$output_dir"

# Loop through each input file
for input_file in "${input_files[@]}"
do
    # Extract the base name (without extension) to use for the output file
    base_name=$(basename "$input_file" .txt)
    output_file="${output_dir}/resultado_${base_name}.txt"

    # Run the C++ program with the input file and save the output to the output file
    ./carousel "$output_file" "$input_file" $initial_temp $cooling_rate $max_iterations
done

# Create or clear the resultados.txt file
result_file="${output_dir}/resultados.txt"
: > "$result_file"

# Loop through each output file and extract the required information
for output_file in "$output_dir"/*.txt
do
    # Read the input file name and the best W from the output file
    input_file=$(grep "Input file:" "$output_file" | awk '{print $3}')
    best_W=$(grep "Best W:" "$output_file" | awk '{print $3}')
    
    # Append the information to resultados.txt
    echo "Input file: $input_file, Best W: $best_W" >> "$result_file"
done



#COOLING RATE
# Parameters for the heuristic
initial_temp=100
cooling_rate=0.90
max_iterations=100

# Convert cooling rate to integer percentage
cooling_rate_percent=$(printf "%.0f" $(echo "$cooling_rate * 100" | bc))

# Create a directory based on the parameters
output_dir="resultado_T${initial_temp}_CR${cooling_rate_percent}_MI${max_iterations}"
mkdir -p "$output_dir"

# Loop through each input file
for input_file in "${input_files[@]}"
do
    # Extract the base name (without extension) to use for the output file
    base_name=$(basename "$input_file" .txt)
    output_file="${output_dir}/resultado_${base_name}.txt"

    # Run the C++ program with the input file and save the output to the output file
    ./carousel "$output_file" "$input_file" $initial_temp $cooling_rate $max_iterations
done

# Create or clear the resultados.txt file
result_file="${output_dir}/resultados.txt"
: > "$result_file"

# Loop through each output file and extract the required information
for output_file in "$output_dir"/*.txt
do
    # Read the input file name and the best W from the output file
    input_file=$(grep "Input file:" "$output_file" | awk '{print $3}')
    best_W=$(grep "Best W:" "$output_file" | awk '{print $3}')
    
    # Append the information to resultados.txt
    echo "Input file: $input_file, Best W: $best_W" >> "$result_file"
done



#MAX ITERATIONS
# Parameters for the heuristic
initial_temp=100
cooling_rate=0.80
max_iterations=1000

# Convert cooling rate to integer percentage
cooling_rate_percent=$(printf "%.0f" $(echo "$cooling_rate * 100" | bc))

# Create a directory based on the parameters
output_dir="resultado_T${initial_temp}_CR${cooling_rate_percent}_MI${max_iterations}"
mkdir -p "$output_dir"

# Loop through each input file
for input_file in "${input_files[@]}"
do
    # Extract the base name (without extension) to use for the output file
    base_name=$(basename "$input_file" .txt)
    output_file="${output_dir}/resultado_${base_name}.txt"

    # Run the C++ program with the input file and save the output to the output file
    ./carousel "$output_file" "$input_file" $initial_temp $cooling_rate $max_iterations
done

# Create or clear the resultados.txt file
result_file="${output_dir}/resultados.txt"
: > "$result_file"

# Loop through each output file and extract the required information
for output_file in "$output_dir"/*.txt
do
    # Read the input file name and the best W from the output file
    input_file=$(grep "Input file:" "$output_file" | awk '{print $3}')
    best_W=$(grep "Best W:" "$output_file" | awk '{print $3}')
    
    # Append the information to resultados.txt
    echo "Input file: $input_file, Best W: $best_W" >> "$result_file"
done