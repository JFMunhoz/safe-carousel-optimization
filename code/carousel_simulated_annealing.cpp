#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>
#include <ctime>
#include <cstdlib>
#include <fstream>
#include <sstream>

// Function to calculate the total weight for each contiguous group of k seats
double calculate_weight(const std::vector<int>& assignment, const std::vector<double>& weights, int k) {
    int n = assignment.size();
    double max_weight = 0;

    for (int i = 0; i < n; i++) {
        double weight = 0;
        for (int j = 0; j < k; j++) {
            weight += weights[assignment[(i + j) % n]];
        }
        max_weight = std::max(max_weight, weight);
    }

    return max_weight;
}

// Function to generate a random initial solution
std::vector<int> generate_initial_solution(int n) {
    std::vector<int> solution(n);
    for (int i = 0; i < n; i++) {
        solution[i] = i;
    }
    std::random_shuffle(solution.begin(), solution.end());
    return solution;
}

// Function to swap two random positions in the assignment
void swap(std::vector<int>& solution) {
    int i = rand() % solution.size();
    int j = rand() % solution.size();
    std::swap(solution[i], solution[j]);
}

// Simulated Annealing to solve the problem
std::vector<int> simulated_annealing(int n, const std::vector<double>& weights, int k, double initial_temp, double cooling_rate, int max_iterations) {
    // Generate the initial solution
    std::vector<int> current_solution = generate_initial_solution(n);
    double current_cost = calculate_weight(current_solution, weights, k);

    std::vector<int> best_solution = current_solution;
    double best_cost = current_cost;

    double temp = initial_temp;

    for (int iter = 0; iter < max_iterations; iter++) {
        // Generate a neighboring solution by swapping two random elements
        std::vector<int> new_solution = current_solution;
        swap(new_solution);

        // Calculate the cost of the new solution
        double new_cost = calculate_weight(new_solution, weights, k);

        // Calculate the difference in cost
        double delta_cost = new_cost - current_cost;

        // If the new solution is better or accepted based on the temperature, accept it
        if (delta_cost < 0 || exp(-delta_cost / temp) > (rand() / double(RAND_MAX))) {
            current_solution = new_solution;
            current_cost = new_cost;

            // Update the best solution found so far
            if (current_cost < best_cost) {
                best_solution = current_solution;
                best_cost = current_cost;
            }
        }

        // Cool down the temperature
        temp *= cooling_rate;
    }

    return best_solution;
}

// Function to read the problem instance from stdin
void read_input(std::vector<double>& weights, int& n) {
    // Read the number of children (n)
    std::cin >> n;
    weights.resize(n);

    // Read the weights of the children
    for (int i = 0; i < n; i++) {
        std::cin >> weights[i];
    }
}

// Function to write the best solution to the specified output file
void write_output(const std::vector<int>& best_solution, const std::string& output_file) {
    std::ofstream out(output_file);
    if (!out) {
        std::cerr << "Failed to open the output file!" << std::endl;
        exit(1);
    }

    // Write the solution (the assignment of children to seats)
    out << "Best solution (assigned seats): ";
    for (int i = 0; i < best_solution.size(); i++) {
        out << best_solution[i] << " ";
    }
    out << std::endl;

    // Write the best cost (maximum weight of any group of k consecutive children)
    double best_cost = calculate_weight(best_solution, weights, best_solution.size() / 2);
    out << "Best cost (maximum weight): " << best_cost << std::endl;

    out.close();
}

// Function to parse the command-line arguments
void parse_args(int argc, char* argv[], double& initial_temp, double& cooling_rate, int& max_iterations, std::string& output_file) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <output_file> [options]" << std::endl;
        exit(1);
    }

    output_file = argv[1];  // First argument is the output file

    // Default parameters for Simulated Annealing
    initial_temp = 1000.0;
    cooling_rate = 0.995;
    max_iterations = 10000;

    // Parse optional parameters
    for (int i = 2; i < argc; i++) {
        std::string arg = argv[i];
        if (arg == "--initial-temp" || arg == "-t") {
            initial_temp = std::stod(argv[++i]);
        } else if (arg == "--cooling-rate" || arg == "-c") {
            cooling_rate = std::stod(argv[++i]);
        } else if (arg == "--max-iterations" || arg == "-i") {
            max_iterations = std::stoi(argv[++i]);
        } else {
            std::cerr << "Unknown argument: " << arg << std::endl;
            exit(1);
        }
    }
}

int main(int argc, char* argv[]) {
    // Parse command-line arguments
    double initial_temp, cooling_rate;
    int max_iterations;
    std::string output_file;
    parse_args(argc, argv, initial_temp, cooling_rate, max_iterations, output_file);

    // Seed the random number generator
    srand(time(0));

    // Read the problem instance from stdin
    int n;
    std::vector<double> weights;
    read_input(weights, n);

    // Solve the problem using simulated annealing
    std::vector<int> solution = simulated_annealing(n, weights, n / 2, initial_temp, cooling_rate, max_iterations);

    // Write the best solution to the output file
    write_output(solution, output_file);

    return 0;
}
