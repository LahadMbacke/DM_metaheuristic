
function reactive_grasp(C, A, vecteur_α, nb_iter, N_α)
    z_meilleur, x_meilleur = 0, zeros(Int64, length(C))
    nb_α = length(vecteur_α)
    probas_α = ones(Float64, nb_α) / nb_α
   

    for i in 1:nb_iter
        a = rand()
        indice_α = findfirst(x -> x >= a, cumsum(probas_α))

        x, z_glouton = greedy_randomized_construction(C, A, vecteur_α[indice_α])

        if z_glouton > z_meilleur
            z_meilleur = z_glouton
            x_meilleur = x
        end
    end

    return x_meilleur, z_meilleur
end

