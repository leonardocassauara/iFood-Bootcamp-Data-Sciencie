import pandas as pd

dados = pd.read_csv('/Dev Week/feedbacks.csv', delimiter=';')

detrators = 0
promoters = 0

notas = dados['nota']

for nota in notas:
	if nota >= 9:
		promoters += 1
	elif nota <= 6:
		detrators += 1

nps = ((promoters - detrators) / len(notas)) * 100
print(nps)