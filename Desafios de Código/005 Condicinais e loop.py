numPedidos = int(input())
pedidos = []

for i in range(1, numPedidos + 1):
    prato = input()
    calorias = int(input())
    ehVegano = input().lower()

    if ehVegano == "s":
        ehVegano = "Vegano"

    elif ehVegano == "n":
        ehVegano = "Nao-vegano"

    pedidos.append(f"Pedido {i}: {prato} ({ehVegano}) - {calorias} calorias\n")

for pedido in pedidos:
    print(pedido)