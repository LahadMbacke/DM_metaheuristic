using LinearAlgebra

function utilities(C,A, r, sr)
     # Vous pouvez calculer les n et m ici
     nb_contraintes, nb_variables = size(A)
     n = [findall(A[i, :] .== 1) for i in 1:nb_contraintes]
     m = [findall(A[:, j] .== 1) for j in 1:nb_variables]
    # Crée un tableau pour stocker les utilités calculées, initialisé à zéro
    utilites = zeros(Float64, length(C))
    
    # Parcours les coûts pour calculer les utilités
    for i in 1:length(C)
        somme_liaisons = 0
        
        # Parcours les liaisons variables pour la contrainte actuelle
        for j in m[i]
            somme_liaisons += sr[j]
        end
        
        # Vérifie si la somme des liaisons variables est différente de zéro
        if somme_liaisons != 0
            # Calcule l'utilité en divisant le coût par la somme des liaisons variables
            utilites[i] = C[i] / somme_liaisons
        end
    end
    
    # Trouve les indices des variables restantes
    indices_r = findall(r .== 1)
    # Sélectionne les utilités correspondant aux variables restantes
    utilites_r = utilites[r .== 1]

    # Retourne les utilités des variables restantes et leurs indices
    return utilites_r, indices_r
end
function greedy_randomized_construction(C, A, alpha)
    # Calcul des nombres de contraintes et de variables
    nb_contraintes, nb_variables = size(A)

    # Calcul des ensembles de contraintes liées à chaque variable et variables liées à chaque contrainte
    contraintes_par_variable = [findall(A[i, :] .== 1) for i in 1:nb_contraintes]
    variables_par_contrainte = [findall(A[:, j] .== 1) for j in 1:nb_variables]

    solution = zeros(Int, nb_variables)  # Initialise la solution avec des zéros
    
    contraintes_restantes = ones(Int, nb_contraintes)  # Un tableau pour suivre les contraintes restantes
    variables_restantes = ones(Int, nb_variables)  # Un tableau pour suivre les variables non encore utilisées
    
    while sum(variables_restantes) > 0  # Tant qu'il reste des variables non utilisées
        # Calcul des utilités des variables restantes et des indices correspondants
        utilites, indices_variables_restantes = utilities(C, A, variables_restantes, contraintes_restantes)
        
        min_utilite = minimum(utilites)  # Calcul de l'utilité minimale
        max_utilite = maximum(utilites)  # Calcul de l'utilité maximale
        limite = min_utilite + alpha * (max_utilite - min_utilite)  # Calcul de la limite pour la liste restreinte
        # Arrondir la valeur 'limite' avec un certain nombre de décimales (ajustez le nombre de décimales au besoin)
        rounded_limite = round(limite, digits=6)

        # Créer une liste restreinte de candidats en recherchant les utilités supérieures ou égales à la valeur arrondie 'rounded_limite'
        rcl = findall(x -> x >= rounded_limite, utilites)
        
        if isempty(rcl)
            break  # Sortir de la boucle si rcl est vide
        end
        
        indice_choisi = indices_variables_restantes[rand(rcl)]  # Choix aléatoire d'un indice parmi les candidats
        solution[indice_choisi] = 1  # Marque la variable choisie comme utilisée
        variables_restantes[indice_choisi] = 0  # Marque la variable choisie comme utilisée dans le tableau
        
        # Dans cette boucle, on exclut les contraintes en conflit avec la solution mise à jour
        for contrainte in variables_par_contrainte[indice_choisi]
            if contraintes_restantes[contrainte] != 0
                for variable in contraintes_par_variable[contrainte]
                    if variable != indice_choisi && variables_restantes[variable] == 1
                        variables_restantes[variable] = 0  # Marque les variables en conflit comme utilisées
                    end
                end
                contraintes_restantes[contrainte] = 0  # Marque la contrainte comme prise en compte
            end
        end
    end
    
    return solution, dot(solution, C)  # Retourne la solution et son coût total
end
