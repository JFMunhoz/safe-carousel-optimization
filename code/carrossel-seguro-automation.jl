using JuMP
using HiGHS
using Printf
using ArgParse  # Para capturar argumentos da linha de comando
using TimerOutputs  # Para medir o tempo de execução

# Função para ler entrada a partir de um arquivo
function read_input(file_name::String)
    open(file_name, "r") do file
        # Leitura do número de crianças (n)
        n = parse(Int, readline(file))
        
        # Leitura dos pesos das crianças (w1, w2, ..., wn)
        weights = parse.(Float64, split(readline(file)))
        
        return n, weights
    end
end

# Função para resolver o problema do carrossel
function solve_carousel(n, weights, time_limit::Int)
    m = n ÷ 2  # k é sempre n/2

    # Criando o modelo usando o solver HiGHS
    model = Model(HiGHS.Optimizer)
    
    # Define the variables
    @variable(model, x[1:n, 1:n], Bin)
    @variable(model, W)
    @variable(model, W_i[1:n])
    @variable(model, p_i[1:n])

    # Step 5: Set up the objective function
    @objective(model, Min, W)

    # Step 6: Set up the constraints
    @constraint(model, [i=1:n], W >= W_i[i])
    @constraint(model, [i=1:n], W_i[i] == sum(p_i[i + k] for k in 0:(div(n, 2)-1) if i + k <= n))
    @constraint(model, [i=1:n], p_i[i] == sum(weights[j] * x[i, j] for j in 1:n))
    @constraint(model, [j=1:n], sum(x[i, j] for i in 1:n) == 1)
    @constraint(model, [i=1:n], sum(x[i, j] for j in 1:n) == 1)

    # Set the time limit for the solver
    set_time_limit_sec(model, time_limit)

    # Step 7: Solve the problem
    optimize!(model)

    # Step 8: Display the results
    println("Optimal value of W: ", value(W))
    println("Optimal assignment:")
    for i in 1:n
        for j in 1:n
            if value(x[i, j]) > 0.5
                println("Child $j is assigned to position $i")
            end
        end
    end

    # Extrai o valor ótimo de W
    W_opt = value(W)
    return W_opt
end


# Função principal que lê a entrada e processa a solução
function main()
    # Define o parser de argumentos
    parser = ArgParseSettings(description="Safe Carousel Optimization")
    @add_arg_table parser begin
        "output_file"
            help = "Output file to save the best solution found"
            required = true
        "input_file"
            help = "Input file containing the number of children and their weights"
            required = true
    end

    # Parse the argumentos
    args = parse_args(parser)

    # Lê a entrada (número de crianças e seus pesos) a partir do arquivo especificado
    n, weights = read_input(args["input_file"])

    # Define o tempo máximo em segundos (30 minutos = 1800 segundos)
    time_limit = 1800

    # Resolve o problema do carrossel
    BKV = solve_carousel(n, weights, time_limit)

    # Imprime a melhor solução na saída padrão
    println("Melhor solução encontrada: ", round(BKV, digits=2))

    # Grava a solução no arquivo de saída
    open(args["output_file"], "w") do file
        println(file, "Melhor solução encontrada: ", round(BKV, digits=2))
    end
end

# Executa a função principal
main()