#!/bin/bash

# List of input files
input_files=("ocs_1.txt" "ocs_2.txt" "ocs_3.txt" "ocs_4.txt" "ocs_5.txt" "ocs_6.txt")

# Loop through each input file
for input_file in "${input_files[@]}"
do
    # Extract the base name (without extension) to use for the output file
    base_name=$(basename "$input_file" .txt)
    output_file="resultado_${base_name}.txt"

    # Run the Julia script with the input file and save the output to the output file
    julia carrossel-seguro.jl "$output_file" "$input_file"
done