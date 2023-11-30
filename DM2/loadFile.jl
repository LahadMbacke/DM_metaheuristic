function loadSPP(fname)
    f=open(fname)
    # lecture du nbre de contraintes (m) et de variables (n)
    m, n = parse.(Int, split(readline(f)) )
    # lecture des n coefficients de la fonction economique et cree le vecteur d'entiers c
    C = parse.(Int, split(readline(f)) )
    # lecture des m contraintes et reconstruction de la matrice binaire A
    A=zeros(Int, m, n)
    for i=1:m
        # lecture du nombre d'elements non nuls sur la contrainte i (non utilise)
        readline(f)
        # lecture des indices des elements non nuls sur la contrainte i
        for valeur in split(readline(f))
          j = parse(Int, valeur)
          A[i,j]=1
        end
    end
    close(f)
    return C, A
end

# function vecteurs_custom(m, est_variable=true)
#     result = []

#     if est_variable
#         sizehint!(result, size(m, 2))

#         for i in 1:size(m, 2)
#             j = 1
#             vect = Vector{Int}(undef, sum(m[:, i]))

#             for k in 1:size(m, 1)
#                 if m[k, i] == 1
#                     vect[j] = k
#                     j = j + 1
#                 end
#             end

#             push!(result, vect)
#         end
#     else
#         sizehint!(result, size(m, 1))

#         for i in 1:size(m, 1)
#             j = 1
#             vect = Vector{Int}(undef, sum(m[i, :]))

#             for k in 1:size(m, 2)
#                 if m[i, k] == 1
#                     vect[j] = k
#                     j = j + 1
#                 end
#             end

#             push!(result, vect)
#         end
#     end

#     return result
# end
