# Using the following packages
using JuMP, GLPK
using LinearAlgebra
import Pkg
Pkg.add("JuMP")


include("grasp.jl")
include("reactive_Grasp.jl")
include("loadFile.jl")


file = "Data/didactic.dat" # Remplacez avec le nom de votre fichier
filename = basename(file)
println("Instance : $filename \n")
C, A = loadSPP(file)

println("Construction avec GRASP d'une solution admissible")
alpha = 0.5
max_iterations = 100
# Mesure du temps pris par GRASP
elapsed_time_grasp = @elapsed begin
    x, z_max = grasp(C, A, alpha, max_iterations)
end

# Afficher les résultats
println("Meilleure solution trouvée : x =", x)
println("Coût de la meilleure solution : z =", z_max)
println("Temps pris par GRASP : $elapsed_time_grasp seconds")

            # Test des α
# println("Testing GRASP with different alpha values")
# alpha_values = 0:0.1:1.0  # Crée une séquence d'alphas de 0 à 1 avec un pas de 0.1
# max_iterations = 100
# for alpha in alpha_values
#     println("Alpha = $alpha")
    
#     # Mesure du temps pris par GRASP avec l'alpha actuel
#     elapsed_time_grasp = @elapsed begin
#         x, z_max = grasp(C, A, alpha, max_iterations)
#     end

#     # Afficher les résultats pour l'alpha actuel
#     println("Meilleure solution trouvée avec alpha = $alpha : x =", x)
#     println("Coût de la meilleure solution avec alpha = $alpha : z =", z_max)
#     println("Temps pris par GRASP avec alpha = $alpha : $elapsed_time_grasp seconds")
# end


# Temps pris par REACTIVE GRASP
println("Construction avec REACTIVE GRASP d'une solution admissible")
vecteur_α = [0.1, 0.2, 0.3, 0.4, 0.5]  # Exemple de vecteur d'alphas
nb_iter = 100  # Nombre d'itérations à exécuter
N_α = 10  # Fréquence de mise à jour des probabilités alpha

# Mesure du temps pris par Reactive GRASP
elapsed_time_reactive_grasp = @elapsed begin
    x_meilleur, z_meilleur = reactive_grasp(C, A, vecteur_α, nb_iter, N_α)
end

# Affichage des résultats
println("Meilleure solution trouvée : ", x_meilleur)
println("Coût de la meilleure solution : ", z_meilleur)
println("Temps pris par REACTIVE GRASP : $elapsed_time_reactive_grasp seconds")


#         #   Test des N_α
# println("Construction avec REACTIVE GRASP d'une solution admissible")
# vecteur_α = [0.1, 0.2, 0.3, 0.4, 0.5]  # Exemple de vecteur d'alphas
# nb_iter = 100  # Nombre d'itérations à exécuter

# # Define a range of N_α values to test
# N_α_values = [5, 10, 15, 20, 25]

# # Create an empty dictionary to store results
# results = Dict{Int, Float64}()

# for N_α in N_α_values
#     # Mesure du temps pris par Reactive GRASP
#     elapsed_time_reactive_grasp = @elapsed begin
#         x_meilleur, z_meilleur = reactive_grasp(C, A, vecteur_α, nb_iter, N_α)
#     end

#     # Store the results in the dictionary
#     results[N_α] = elapsed_time_reactive_grasp

#     # Affichage des résultats
#     println("N_α = $N_α")
#     println("Meilleure solution trouvée : ", x_meilleur)
#     println("Coût de la meilleure solution : ", z_meilleur)
#     println("Temps pris par REACTIVE GRASP : $elapsed_time_reactive_grasp seconds\n")
# end

# # Print the results after each iteration
# println("Results for different N_α values:")
# for (N_α, elapsed_time) in results
#     println("N_α = $N_α, Temps pris : $elapsed_time seconds")
# end
