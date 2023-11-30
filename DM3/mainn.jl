using JuMP, GLPK
using LinearAlgebra
import Pkg
include("loadFile.jl")


# Chargement des données depuis le fichier
function loadSPP(fname)
    f = open(fname)
    # lecture du nbre de contraintes (m) et de variables (n)
    m, n = parse.(Int, split(readline(f)))
    # lecture des n coefficients de la fonction économique et création du vecteur d'entiers c
    C = parse.(Int, split(readline(f)))
    # lecture des m contraintes et reconstruction de la matrice binaire A
    A = zeros(Int, m, n)
    for i = 1:m
        # lecture du nombre d'éléments non nuls sur la contrainte i (non utilisé)
        readline(f)
        # lecture des indices des éléments non nuls sur la contrainte i
        for valeur in split(readline(f))
            j = parse(Int, valeur)
            A[i, j] = 1
        end
    end
    close(f)
    return C, A, m, n
end

# Fitness function
function calculate_fitness(individual, coefficients, constraints)
    fitness = sum(coefficients[i] * individual[i] for i in 1:length(individual))

    # Reduce fitness for each constraint that is not satisfied
    for constraint in constraints
        if sum(individual[i] for i in constraint) > 1
            fitness -= 1
        end
    end

    return fitness
end
# Génération d'une population initiale aléatoire
function generate_population(pop_size, n)
    population = BitArray[]
    for _ in 1:pop_size
        individual = BitArray(rand(Bool, n))
        push!(population, individual)
    end
    return population
end

## Sélection par rang
function rank_selection(population, fitness_values, num_parents)
    sorted_indices = sortperm(fitness_values, rev=true)
    selected_parents = population[sorted_indices[1:num_parents]]
    return selected_parents
end

# Croisement (Crossover)
function crossover(parent1, parent2)
    crossover_point = rand(1:length(parent1))
    offspring = [parent1[1:crossover_point]; parent2[crossover_point+1:end]]
    return BitArray(offspring)
end

# Mutation and repair function
function mutate_and_repair(individual, mutation_probability, constraints)
    # Mutation
    for i in 1:length(individual)
        if rand() < mutation_probability
            individual[i] = !individual[i]
        end
    end

    # Repair
    for constraint in constraints
        while sum(individual[constraint]) > 1
            # If the constraint is violated, fix it by turning off a randomly chosen variable
            idx_to_change = rand(constraint)
            individual[idx_to_change] = false
        end
    end
end

# Genetic algorithm
function genetic_algorithm(coefficients, constraints, population_size, num_generations, mutation_probability)
    # Initialize population
    population = [rand(Bool, length(coefficients)) for _ in 1:population_size]

    for generation in 1:num_generations
        # Calculate fitness
        fitnesses = [calculate_fitness(individual, coefficients, constraints) for individual in population]

        # Select parents and perform crossover and mutation
        new_population = []
        for _ in 1:population_size
            parents = rank_selection(population, fitnesses, 2)
            offspring = crossover(parents[1], parents[2])
            mutate_and_repair(offspring, mutation_probability, constraints)
            push!(new_population, offspring)
        end

        # Replace old population with new population
        population = new_population
    end

    # Return the best solution
    fitnesses = [calculate_fitness(individual, coefficients, constraints) for individual in population]
    best_index = argmax(fitnesses)
    return population[best_index]
end

# Charger les données depuis le fichier didactic.dat
C, A, m, n = loadSPP("Data/pb_100rnd0100.dat")
constraints = [findall(A[i, :] .== 1) for i in 1:m]

# Exemple d'utilisation avec les données chargées
population_size = 500
max_generations = 100
mutation_probability =  0.01

solution = genetic_algorithm(C, constraints, population_size, max_generations, mutation_probability)
println("Solution finale : ", solution)
fitness = calculate_fitness(solution, C, constraints)
println("Fitness de la solution finale : ", fitness)