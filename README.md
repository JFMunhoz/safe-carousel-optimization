# Safe Carousel Problem (Carrossel Seguro)

This repository contains the mathematical formulation and implementation of a metaheuristic solution for the **Safe Carousel Problem (Carrossel Seguro)**. The project utilizes the **Simulated Annealing** algorithm to optimize the distribution of children on a carousel to minimize weight imbalances.

## Problem Description
Given a carousel with `n` equidistant seats and `n = 2k` children with weights `w1, w2, ..., wn ≥ 0`, the goal is to assign each child to a seat such that the maximum weight sum across any set of `k` consecutive seats is minimized.

### Mathematical Formulation
The problem is represented mathematically with constraints and an objective function to minimize the maximum weight (`W`). Decision variables are binary, ensuring each seat and child is assigned uniquely. For more details, see the LaTeX document in this repository.

## Simulated Annealing Algorithm
The **Simulated Annealing** algorithm is used to explore the solution space efficiently. Key features include:
- Initial random solution generation.
- Neighborhood search via random swaps.
- Acceptance criteria based on temperature and objective improvement.
- Gradual cooling to refine the search.

### Parameters
- **Initial Temperature (`initial_temp`)**: Controls the acceptance of suboptimal solutions.
- **Cooling Rate (`cooling_rate`)**: Determines the rate of temperature reduction.
- **Max Iterations (`max_iterations`)**: The number of iterations per temperature step.

## Project Structure
- `src/`: Contains the C++ implementation of the Simulated Annealing algorithm.
- `latex/`: Includes the LaTeX document with mathematical formulation.
- `results/`: Performance results on various test instances.
- `README.md`: This file.

## Results
Testing was performed on instances with varying numbers of children. Comparisons were made with the HiGHS solver for validation. The results showed promising solutions with low deviation from the best-known values (BKV).

### Test Platforms
- **OS**: Ubuntu 24.04.1 LTS
- **CPU**: Intel i5-1235U
- **Memory**: 16 GB
- **Languages**: C++ (Simulated Annealing), Julia (HiGHS Solver)

## How to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/username/safe-carousel.git
   cd safe-carousel
2. Compile the Simulated Annealing algorithm:
   g++ -o simulated_annealing src/simulated_annealing.cpp
3. Run the algorithm:
   ./simulated_annealing <input_file> <initial_temp> <cooling_rate> <max_iterations>

Created by João Francisco Hirtenkauf Munhoz and Leonardo Heisler, November 2024.
