# Limite: 1500 (500 por saque, 3 saques no maximo)

saldo   = 0
limite  = 500
extrato = ''
numero_saques = 0
LIMITE_SAQUES = 3
contador_operacoes = 1

while True:
    print("""
[1] Depositar
[2] Sacar
[3] Extrato
[4] Sair""")

    menu = int(input("Selecione a operação desejada > "))
    print()

    if menu == 1:
        deposito = float(input("Digite o valor do depósito > R$"))

        if deposito > 0:
            saldo += deposito
            extrato = extrato + f"No.{contador_operacoes}       Depósito       R${deposito:.2f}\n"
            contador_operacoes += 1
        else:
            print("Depósito invalidado. Valor inválido. Tente novamente com outro valor")


    elif menu == 2:
        saque = float(input("Digite o valor do saque > R$"))

        if LIMITE_SAQUES > 0:
            if saque > 500:
                print("Saque invalidado. O limite por saque é de R$500,00. Tente novamente com outro valor")
            elif saque > saldo:
                print("Saque invalidado. Não há fundos disponíveis para essa operação.")
            else:
                saldo -= saque
                extrato = extrato + f"No.{contador_operacoes}       Saque          R${saque:.2f}\n"
                LIMITE_SAQUES -= 1
                contador_operacoes += 1
        else:
            print("Saque invalidado. Você atingiu o limite diário de saques.")

    elif menu == 3:
        print("EXTRATO".center(35, "="))
        print("Não foram realizadas movimentações." if not extrato else extrato)
        print(f"Saldo: R${saldo:.2f}".rjust(35, "="))

    elif menu == 4:
        print("Encerrando...")
        break

    else:
        print('Opção inválida, por favor selecione novamente a operação desejada')
