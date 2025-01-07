#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <cstdlib>
#include <ctime>
#include <algorithm>

// Function to read input from file
void read_input(const std::string& input_file, int& n, std::vector<int>& weights) {
    std::ifstream infile(input_file);
    if (!infile) {
        std::cerr << "Error opening input file: " << input_file << std::endl;
        exit(1);
    }
    infile >> n;
    weights.resize(n);
    for (int i = 0; i < n; ++i) {
        infile >> weights[i];
    }
}

// Function to compute the objective function W
int compute_W(const std::vector<int>& assignment, const std::vector<int>& weights, int k) {
    int n = weights.size();
    std::vector<int> W(n, 0);
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < k; ++j) {
            W[i] += weights[assignment[(i + j) % n]];
        }
    }
    return *std::max_element(W.begin(), W.end());
}

// Simulated annealing algorithm
std::vector<int> simulated_annealing(const std::vector<int>& initial_solution, double initial_temp, double cooling_rate, int max_iterations, const std::string& input_file) {
    int n = initial_solution.size();
    int k = n / 2;
    std::vector<int> best_solution = initial_solution;
    int best_W = compute_W(best_solution, initial_solution, k);

    double temp = initial_temp;
    std::vector<int> current_solution = initial_solution;
    int current_W = best_W;

    while (temp > 1e-10) {
        for (int i = 0; i < max_iterations; ++i) {
            std::vector<int> new_solution = current_solution;
            int pos1 = rand() % n;
            int pos2 = rand() % n;
            std::swap(new_solution[pos1], new_solution[pos2]);

            int new_W = compute_W(new_solution, initial_solution, k);
            int delta = new_W - current_W;

            if (delta <= 0 || exp(-delta / temp) > ((double)rand() / RAND_MAX)) {
                current_solution = new_solution;
                current_W = new_W;
                if (current_W < best_W) {
                    best_solution = current_solution;
                    best_W = current_W;
                    // Print the input file name and the best solution so far
                    std::cout << "Input file: " << input_file << ", Best W: " << best_W << std::endl;
                }
            }
        }
        temp *= cooling_rate;
    }

    return best_solution;
}

// Function to save the result to output file
void save_output(const std::string& output_file, const std::string& input_file, double initial_temp, double cooling_rate, int max_iterations, const std::vector<int>& solution, int best_W) {
    std::ofstream outfile(output_file);
    if (!outfile) {
        std::cerr << "Error opening output file: " << output_file << std::endl;
        exit(1);
    }
    outfile << "Input file: " << input_file << std::endl;
    outfile << "Initial temperature: " << initial_temp << std::endl;
    outfile << "Cooling rate: " << cooling_rate << std::endl;
    outfile << "Max iterations: " << max_iterations << std::endl;
    outfile << "Best W: " << best_W << std::endl;
    outfile << "Best Assignment: ";
    for (int i = 0; i < solution.size(); ++i) {
        outfile << solution[i] << " ";
    }
    outfile << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc != 6) {
        std::cerr << "Usage: " << argv[0] << " <output_file> <input_file> <initial_temp> <cooling_rate> <max_iterations>" << std::endl;
        return 1;
    }

    std::string output_file = argv[1];
    std::string input_file = argv[2];
    double initial_temp = atof(argv[3]);
    double cooling_rate = atof(argv[4]);
    int max_iterations = atoi(argv[5]);

    srand(time(0));

    int n;
    std::vector<int> weights;
    read_input(input_file, n, weights);

    // Use the weights as the initial solution
    std::vector<int> initial_solution = weights;

    std::vector<int> best_solution = simulated_annealing(initial_solution, initial_temp, cooling_rate, max_iterations, input_file);
    int best_W = compute_W(best_solution, weights, n / 2);

    save_output(output_file, input_file, initial_temp, cooling_rate, max_iterations, best_solution, best_W);

    return 0;
}