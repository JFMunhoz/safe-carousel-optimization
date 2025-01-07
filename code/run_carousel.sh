#!/bin/bash

# Loop through each input file
for input_file in ocs_*.txt; do
    # Extract the number from the input file name
    number=$(echo $input_file | grep -o -E '[0-9]+')
    
    # Define the output file name
    output_file="output_ocs_$number.txt"
    
    # Run the Julia program with the input and output files
    julia carrossel-seguro-automation.jl $output_file $input_file
done