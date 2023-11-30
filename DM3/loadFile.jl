# Chargement des données depuis le fichier
function loadSPP(fname)
  f = open(fname)
  # Lecture du nombre de contraintes (m) et de variables (n)
  m, n = parse.(Int, split(readline(f)))
  # Lecture des coefficients de la fonction économique et création du vecteur d'entiers c
  C = parse.(Int, split(readline(f)))
  # Lecture des m contraintes et reconstruction de la matrice binaire A
  A = zeros(Int, m, n)
  for i = 1:m
      # Lecture du nombre d'éléments non nuls sur la contrainte i (non utilisé)
      readline(f)
      # Lecture des indices des éléments non nuls sur la contrainte i
      for valeur in split(readline(f))
          j = parse(Int, valeur)
          A[i, j] = 1
      end
  end
  close(f)
  return C, A, m, n
end