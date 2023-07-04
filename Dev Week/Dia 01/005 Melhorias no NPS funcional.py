import pandas as pd


def calcularNPS(notas):
    detrators = notas[notas <= 6].count()
    promoters = notas[notas >= 9].count()

    return ((promoters - detrators) / len(notas)) * 100


dados = pd.read_csv('/Dev Week/feedbacks.csv', delimiter=';')
notas = dados['nota']
NPS = calcularNPS(notas)

print(NPS)