#!/bin/bash

# Loop through each input file
for input_file in ocs_*.txt; do
    # Extract the number from the input file name
    number=$(echo $input_file | grep -o -E '[0-9]+')
    
    # Define the output file name
    output_file="output_ocs_$number.txt"
    
    # Run the C++ program with the input and output files
    ./carousel $output_file $input_file 1000 0.95 1000
done