valorHamburguer      = float(input())
quantidadeHamburguer = int(input())
valorBebida          = float(input())
quantidadeBedida     = int(input())
valorPago            = float(input())

valorProduto         = (valorHamburguer * quantidadeHamburguer) + (valorBebida * quantidadeBedida)
troco                = valorPago - valorProduto

if troco < 0:
    troco = 0

print(f"O preço final do pedido é R$ {valorProduto:.2f}. Seu troco é R$ {troco:.2f}.")