using JuMP
using HiGHS
using Printf
using ArgParse  # Para capturar argumentos da linha de comando

# Função para ler entrada a partir da entrada padrão
function read_input()
    # Leitura do número de crianças (n)
    n = parse(Int, readline())
    
    # Leitura dos pesos das crianças (w1, w2, ..., wn)
    weights = parse.(Float64, split(readline()))
    
    return n, weights
end

# Função para resolver o problema do carrossel
function solve_carousel(n, weights)
    k = n ÷ 2  # k é sempre n/2

    # Criando o modelo usando o solver HiGHS
    model = Model(HiGHS.Optimizer)
    
    # Variáveis de decisão x[i, j] = 1 se a criança j sentar no assento i
    @variable(model, x[1:n, 1:n], Bin)
    
    # Definindo a variável W (o peso máximo das k cadeiras consecutivas)
    @variable(model, W >= 0)
    
    # Objetivo: minimizar W
    @objective(model, Min, W)

    # Restrições: Cada criança deve sentar em exatamente um assento
    for j in 1:n
        @constraint(model, sum(x[i, j] for i in 1:n) == 1)
    end

    # Cada assento deve ser ocupado por exatamente uma criança
    for i in 1:n
        @constraint(model, sum(x[i, j] for j in 1:n) == 1)
    end

    # Definindo o peso W_i para cada grupo de assentos i
    for i in 1:n
        @constraint(model, W >= sum(weights[(i + l - 1) % n + 1] * x[(i + l - 1) % n + 1, j] for l in 1:k for j in 1:n))
    end

    # Resolve o modelo
    optimize!(model)

    # Extrai o valor ótimo de W
    W_opt = value(W)
    return W_opt
end

# Função principal que lê a entrada e processa a solução
function main()    
    # Lê a entrada (número de crianças e seus pesos)
    n, weights = read_input()

    # Resolve o problema do carrossel
    BKV = solve_carousel(n, weights)

    # Imprime a melhor solução na saída padrão
    println("Melhor solução encontrada: ", round(BKV, digits=2))

    # Grava a solução no arquivo de saída
    open(ARGS[1], "w") do file
        println(file, "Melhor solução encontrada: ", round(BKV, digits=2))
    end
end

# Executa a função principal
main()
