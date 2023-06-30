import pandas as pd


def calcularNPS(notas):
    detrators = 0
    promoters = 0

    for nota in notas:
        if nota >= 9:
            promoters += 1
        elif nota <= 6:
            detrators += 1

    NPS = ((promoters - detrators) / len(notas)) * 100

    return NPS


dados = pd.read_csv('/Dev Week/feedback.csv', delimiter=';')
notas = dados['nota']
NPS = calcularNPS(notas)

print(NPS)