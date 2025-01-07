#!/bin/bash

# List of input files
input_files=("ocs_1.txt" "ocs_2.txt" "ocs_3.txt" "ocs_4.txt" "ocs_5.txt" "ocs_6.txt" "ocs_7.txt" "ocs_8.txt" "ocs_9.txt" "ocs_10.txt")

# Parameters for the heuristic
initial_temp=1000
cooling_rate=0.80
max_iterations=1000

# Convert cooling rate to integer percentage
cooling_rate_percent=$(printf "%.0f" $(echo "$cooling_rate * 100" | bc))

# Loop through each input file
for input_file in "${input_files[@]}"
do
    # Extract the base name (without extension) to use for the output file
    base_name=$(basename "$input_file" .txt)
    output_file="resultado_${base_name}_T${initial_temp}_CR${cooling_rate_percent}_MI${max_iterations}.txt"

    # Run the C++ program with the input file and save the output to the output file
    ./carousel "$output_file" "$input_file" $initial_temp $cooling_rate $max_iterations
done