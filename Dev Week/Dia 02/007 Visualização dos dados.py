import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import pandas as pd


def calcularNPS():
    dados = pd.read_csv('/Dev Week/feedbacks.csv', delimiter=';')
    notas = dados['nota']
    detrators = notas[notas <= 6].count()
    promoters = notas[notas >= 9].count()

    return ((promoters - detrators) / len(notas)) * 100


NpsZonas = ['Crítico', 'Aperfeiçoamento', 'Qualidade', 'Excelência']
NpsValores = [-100, 0, 50, 75, 100]
NpsCores = ['#FF595E', '#FFCA3A', '#8AC926', '#1982C4']


def criarGraficoNps(nps):
    fig, ax = plt.subplots(figsize=(10, 2))

    for i, zona in enumerate(NpsZonas):
        ax.barh([0], width=NpsValores[i+1]-NpsValores[i], left=NpsValores[i], color=NpsCores[i])

    ax.barh([0], width=0.5, left=nps, color='black')
    ax.set_yticks([])
    ax.set_xlim(-100, 100)
    ax.set_xticks(NpsValores)

    plt.text(nps, 0, f'{nps:.2f}', ha='center', va='center', color='white', bbox=dict(facecolor='black'))

    patches = [mpatches.Patch(color=NpsCores[i], label=NpsZonas[i]) for i in range(len(NpsZonas))]
    plt.legend(handles=patches, bbox_to_anchor=(1, 1))

    plt.title('NPS')

    plt.show()

Nps = calcularNPS()
criarGraficoNps(Nps)