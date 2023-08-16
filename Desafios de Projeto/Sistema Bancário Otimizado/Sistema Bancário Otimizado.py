def imprimir_menu():
    print("""
        [1] Depósito
        [2] Saque
        [3] Consultar Extrato
        [4] Novo Usuário
        [5] Nova Conta
        [6] Listar Contas
        [7] Sair
        """)

    menu = int(input("Menu > "))

    return menu


def sacar(*, saldo, valor, extrato, limite, numero_saques, limite_saques):
    if numero_saques == limite_saques:
        print(f"\033[31mErro: limite diário de saques ({limite_saques}) foi atingido.\033[m")

    else:
        if valor <= saldo:
            if valor <= 0:
                print("\033[31mErro: valor de saque inválido.\033[m")

            elif valor > limite:
                print(f"\033[31mErro: limite por saque (R${limite:.2f}) foi atingido.\n\033[m")

            else:
                saldo -= valor
                numero_saques += 1
                extrato += f"Saque             R${valor:.2f}\n"
                print("\033[32mOperação de saque executada com sucesso.\033[m")

        else:
            print("\033[31mErro: não há fundos suficientes.\033[m")

    return saldo, extrato, numero_saques


def depositar(saldo, valor, extrato, /):
    if valor <= 0:
        print("\033[31mErro: valor inválido\033[m")

    else:
        saldo += valor
        extrato += f"Depósito          R${valor:.2f}\n"
        print("\033[32mOperação de depósito executada com sucesso.\033[m")

    return saldo, extrato


def consultar_extrato(saldo, /, *, extrato):
    if extrato:
        print("EXTRATO".center(27,"="))
        print(extrato)
        print(f"Saldo: R${saldo:.2f}".rjust(27,"="))
    else:
        print("\033[31mNão foram feitas movimentações.\033[m")

    return


def filtrar_usuario(cpf, usuarios):
    usuarios_filtrados = [usuario for usuario in usuarios if usuario["CPF"] == cpf]
    return usuarios_filtrados[0] if usuarios_filtrados else None


def criar_usuario(usuarios):
    usuario = {
        "nome": str(input("Nome: ")),
        "data de nascimento": str(input("Data de nascimento (DD/MM/AAAA): ")),
        "CPF": str(input("CPF: ")).replace(".","").replace("-","")
    }

    logradouro = str(input("Logradouro: "))
    numero_casa = int(input("Número da casa: "))
    bairro = str(input("Bairro: "))
    cidade = str(input("Cidade/Estado: "))

    usuario["endereço"] = f"{logradouro}, {numero_casa} - {bairro} - {cidade}"

    if filtrar_usuario(usuario["CPF"], usuarios):
        print("\033[31mErro: usuário já cadastrado.\033[m")
    else:
        usuarios.append(usuario)
        print("\033[32mUsuário registrado com sucesso.\033[m")

    return usuarios


def criar_conta(contas, usuarios, agencia):
    cpf     = str(input("CPF: ")).replace(".","").replace("-","")
    usuario = filtrar_usuario(cpf, usuarios)

    if usuario:
        conta = {
            "agencia": agencia,
            "numero da conta": len(contas) + 1,
            "usuario": usuario
        }
        contas.append(conta)
        print("\033[32mConta registrada com sucesso!\033[m")
    else:
        print("\033[31mErro: CPF não registrado no sistema.\033[m")

    return contas


def listar_contas(contas):
    if contas:
        separador = "="*27
        for conta in contas:
            print(f"""\033[32mAgência:\t\t{conta['agencia']}\nC/C:\t\t\t{conta['numero da conta']}\nTitular:\t\t{conta['usuario']['nome']}\n{separador}\033[m""")
    else:
        print("\033[31mErro: nenhuma conta foi registrada.\033[m")


def main():
    AGENCIA  = "0001"
    contas   = []
    usuarios = []
    saldo    = 0
    limite   = 500
    extrato  = ''
    numero_saques = 0
    LIMITE_SAQUES = 3

    while True:
        menu = imprimir_menu()

        if menu == 1:
            valor = float(input("Digite o valor para depósito: R$"))
            saldo, extrato = depositar(saldo, valor, extrato)

        elif menu == 2:
            valor = float(input("Digite o valor para saque: R$"))
            saldo, extrato, numero_saques = sacar(saldo=saldo, valor=valor, extrato=extrato, limite=limite, numero_saques=numero_saques, limite_saques=LIMITE_SAQUES)

        elif menu == 3:
            consultar_extrato(saldo, extrato=extrato)

        elif menu == 4:
            usuarios = criar_usuario(usuarios)


        elif menu == 5:
            contas = criar_conta(contas, usuarios, AGENCIA)

        elif menu == 6:
            listar_contas(contas)

        elif menu == 7:
            print("\033[32mEncerrando...\033[m")
            break

        else:
            print("\033[31mErro: opção inválida.\033[m")


main()