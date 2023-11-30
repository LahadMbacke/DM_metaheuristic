# README - Algorithmes Greedy Randomized et Reactive GRASP pour le Problème du Set Packing (SPP)

Ce document présente une implémentation en Julia d'algorithmes Greedy Randomized et Reactive GRASP pour résoudre le Problème du Set Packing (SPP). Le SPP est un problème d'optimisation combinatoire qui consiste à sélectionner un ensemble de sous-ensembles (sets) non conflictuels tout en maximisant leur nombre. Chaque sous-ensemble a un coût associé, et l'objectif est de maximiser le nombre de sous-ensembles choisis sans dépasser un certain budget.

## Fichiers

Le code est divisé en trois fichiers principaux :

- `grasp.jl` : Contient l'implémentation de l'algorithme Greedy Randomized.
- `greedy_randomized.jl` : Contient des fonctions utilitaires utilisées par l'algorithme Greedy Randomized.
- `reactive_grasp.jl` : Contient l'implémentation de l'algorithme Reactive GRASP.

## Utilisation

Pour utiliser ces algorithmes, vous devez inclure les fichiers nécessaires dans votre environnement Julia en utilisant `include("nom_du_fichier.jl")`.

### Utilisation de GRASP



include("grasp.jl")

# Appel de la fonction grasp
x_max, z = grasp(C, A, alpha, max_iterations)

# Explication des paramètres :
- C : Un tableau des coûts associés à chaque sous-ensemble.
- A : Une matrice binaire représentant les contraintes et les intersections entre les sous-ensembles.
- alpha : Un paramètre contrôlant le caractère aléatoire de l'algorithme.
- max_iterations : Le nombre maximal d'itérations pour l'algorithme.

La fonction retourne :
- x_max : Le vecteur binaire de solution indiquant quels sous-ensembles sont sélectionnés (1) et lesquels ne le sont pas (0).
- z : Le coût total des sous-ensembles sélectionnés. 


### Utilisation de Reactive GRASP


include("reactive_grasp.jl")

# Appel de la fonction reactive_grasp
x_meilleur, z_meilleur = reactive_grasp(C, A, vecteur_α, nb_iter, N_α)

Explication des paramètres :
- C : Un tableau des coûts associés à chaque sous-ensemble.
- A : Une matrice binaire représentant les contraintes et les intersections entre les sous-ensembles.
- vecteur_α : Un vecteur de valeurs alpha pour l'algorithme Reactive GRASP.
- nb_iter : Le nombre d'itérations à exécuter.
- N_α : La fréquence de mise à jour des probabilités alpha.

La fonction retourne :
- x_meilleur : Le vecteur binaire de solution pour la meilleure solution trouvée.
- z_meilleur : Le coût de la meilleure solution trouvée.
