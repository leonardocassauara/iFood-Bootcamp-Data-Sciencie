import pandas as pd


class Feedback:
    def __init__(self, nota, comentario):
        self.nota = nota
        self.comentario = comentario


class FeedbackAnalyzer:
    def __init__(self, feedbacks):
        self.feedbacks = feedbacks

    def calcularNPS(self):
        promoters = 0
        detrators = 0

        for feedback in self.feedbacks:
            if feedback.nota >= 9:
                promoters += 1
            elif feedback.nota <= 6:
                detrators += 1

        NPS = ((promoters - detrators) / len(self.feedbacks)) * 100
        return NPS


dados = pd.read_csv('Dev Week/feedbacks.csv', delimiter=';')

feedbacks = [Feedback(linha['nota'], linha['comentario']) for index, linha in dados.iterrows()]

for feedback in feedbacks:
    print("{}\t{}".format(feedback.nota, feedback.comentario))

analisador = FeedbackAnalyzer(feedbacks)
print('\nNPS:  ', analisador.calcularNPS())