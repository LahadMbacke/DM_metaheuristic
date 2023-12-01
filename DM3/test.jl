using JuMP, GLPK
using LinearAlgebra
import Pkg
include("loadFile.jl")

# Fonction de fitness
function calculate_fitness(individual, coefficients, constraints)
    fitness = sum(coefficients[i] * individual[i] for i in 1:length(individual))

    # Réduire la fitness pour chaque contrainte non satisfaite
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

# Fonction de mutation et réparation
function mutate_and_repair(individual, mutation_probability, constraints)
    # Mutation
    for i in 1:length(individual)
        if rand() < mutation_probability
            individual[i] = !individual[i]
        end
    end

    # Réparation
    for constraint in constraints
        while sum(individual[constraint]) > 1
            # Si la contrainte est violée, la corriger en désactivant une variable choisie au hasard
            idx_to_change = rand(constraint)
            individual[idx_to_change] = false
        end
    end
end


using Plots

# Algorithme génétique
function genetic_algorithm(coefficients, constraints, population_size, num_generations, mutation_probability)
    # Initialiser la population
    population = [rand(Bool, length(coefficients)) for _ in 1:population_size]

    # Initialiser le tableau pour stocker la fitness maximale de chaque génération
    max_fitness_values = []

    for generation in 1:num_generations
        # Calculer la fitness
        fitnesses = [calculate_fitness(individual, coefficients, constraints) for individual in population]

        # Enregistrer la fitness maximale de cette génération
        push!(max_fitness_values, maximum(fitnesses))

        # Sélection des parents et réalisation du croisement et de la mutation
        new_population = []
        for _ in 1:population_size
            parents = rank_selection(population, fitnesses, 2)
            offspring = crossover(parents[1], parents[2])
            mutate_and_repair(offspring, mutation_probability, constraints)
            push!(new_population, offspring)
        end

        # Remplacer l'ancienne population par la nouvelle population
        population = new_population
    end

    # Retourner la meilleure solution et les valeurs de fitness maximales
    fitnesses = [calculate_fitness(individual, coefficients, constraints) for individual in population]
    best_index = argmax(fitnesses)
    return population[best_index], max_fitness_values
end
# Charger les données depuis le fichier didactic.dat
C, A, m, n = loadSPP("Data/pb_1000rnd0100.dat")
constraints = [findall(A[i, :] .== 1) for i in 1:m]
# Exemple d'utilisation avec les données chargées
# population_size = 500
max_generations = 100
# mutation_probability = 0.01

# solution, max_fitness_values = genetic_algorithm(C, constraints, population_size, max_generations, mutation_probability)
# println("Solution finale : ", solution)
# fitness = calculate_fitness(solution, C, constraints)
# println("Fitness de la solution finale : ", fitness)
# using Plots

# Définir les valeurs de mutation_probability et population_size à tester
mutation_probabilities = [0.001,0.01, 0.05, 0.1]
population_sizes = [100, 500, 1000]

# Initialiser un graphique
p = plot()

# Pour chaque combinaison de mutation_probability et population_size
for (mutation_prob, pop_size) in Iterators.product(mutation_probabilities, population_sizes)
    # Exécuter l'algorithme génétique
    global solution, max_fitness_values = genetic_algorithm(C, constraints, pop_size, max_generations, mutation_prob)

    # Calculer la fitness de la solution
    global fitness = calculate_fitness(solution, C, constraints)

    # Imprimer la solution et sa fitness
    println("Mutation Prob: $mutation_prob, Pop Size: $pop_size, Solution: $solution, Fitness: $fitness")

    # Tracer la courbe de la fitness maximale en fonction des générations
    plot!(p, 1:max_generations, max_fitness_values, label="Mutation Prob: $mutation_prob, Pop Size: $pop_size, Meill Solu: $fitness")
end
# Ajouter des labels aux axes
xlabel!(p, "Generation")
ylabel!(p, "Solutions")

# Afficher le graphique
display(p)