include("greedy_Randomized.jl")


function grasp(C, A, alpha, max_iterations)
    #z_max::Int64 = 0
    x_max::Vector{Int} = zeros(Int, length(C))
    z::Int64 = 0
    
    for iteration in 1:max_iterations
        # Utilise l'algorithme de construction randomisée glouton
        x_max, z = greedy_randomized_construction(C, A, alpha)
    end
    return x_max, z
end
