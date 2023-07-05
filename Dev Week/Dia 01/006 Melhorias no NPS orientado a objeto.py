import pandas as pd


class Feedback:
    def __init__(self, nota, comentario):
        self.nota = nota
        self.comentario = comentario


class FeedbackAnalyzer:
    def __init__(self, feedbacks):
        self.feedbacks = feedbacks

    def calcularNPS(self):
        detrators = sum(1 for feedback in self.feedbacks if feedback.nota <= 6)
        promoters = sum(1 for feedback in self.feedbacks if feedback.nota >=9)

        NPS = ((promoters - detrators) / len(self.feedbacks)) * 100
        return NPS


dados = pd.read_csv('/Dev Week/feedbacks.csv', delimiter=';')

feedbacks = dados.apply(lambda linha: Feedback(linha['nota'], linha['comentario']), axis=1)

for feedback in feedbacks:
    print("{}\t{}".format(feedback.nota, feedback.comentario))

analisador = FeedbackAnalyzer(feedbacks)
print('\nNPS:  ', analisador.calcularNPS())