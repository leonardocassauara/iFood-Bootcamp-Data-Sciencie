def main():
    n = int(input())
    total = 0

    for i in range(1, n + 1):
        pedido = input().split()
        nome   = pedido[0]
        valor  = float(pedido[1])
        total += valor

    cupom = str(input())
    if cupom[:2] == str(10):
        total *= 0.9

    elif cupom[:2] == str(20):
        total *= 0.8

    print(f"Valor total: {total:.2f}")

main()