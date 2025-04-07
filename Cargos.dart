import 'package:experimentos/DataBase.dart';
import 'package:flutter/material.dart';

selectrow(
    {required context,
    required String? titulo,
    required String? elemento,
    required String? texto1,
    required String? texto2,
    required String? texto3,
    required funcao,
    // O valor nessa função serve pra já ter um valor prévio, para toda vez que
    // a função é chamada novamente os icones selecionados não se alterem
    int? valor}) {
  valor ??= 0;
  ValueNotifier<bool> isCheckedNotifier1 = ValueNotifier<bool>(true);
  ValueNotifier<bool> isCheckedNotifier2 =
      valor >= 1 ? ValueNotifier<bool>(true) : ValueNotifier<bool>(false);
  ValueNotifier<bool> isCheckedNotifier3 =
      valor >= 2 ? ValueNotifier<bool>(true) : ValueNotifier<bool>(false);

  SetValue(value) {
    if (value == 0) {
      isCheckedNotifier2.value = false;
      isCheckedNotifier3.value = false;
    }
    if (value == 1) {
      isCheckedNotifier2.value = true;
      isCheckedNotifier3.value = false;
    }
    if (value == 2) {
      isCheckedNotifier2.value = true;
      isCheckedNotifier3.value = true;
    }
  }

  // row para colocar a linha vertical
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //Sized Box para dar espaçamento com a borda da janela
      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
      //linha lateral
      Container(
          width: 1,
          height: MediaQuery.of(context).size.height * 0.15,
          color: Colors.white),
      // coluna com as opções
      Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo!, style: TextStyle(fontSize: 20)),
            // aqui são tes rows para possibilitar uma linha vertical antes do texto
            Row(
              children: [
                //linha vertical
                Container(width: 10, height: 1, color: Colors.white),
                ValueListenableBuilder(
                    valueListenable: isCheckedNotifier1,
                    builder: (context, isChecked, child) {
                      return SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: isChecked,

                          onChanged: (bool? value) {
                            SetValue(0);
                            funcao(elemento, 0);
                          },
                          shape: CircleBorder(), // Transforma em círculo
                          side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  )), // Borda branca
                          checkColor:
                              Colors.transparent, // Cor da marca de seleção
                          activeColor:
                              Colors.green, // Preenchimento quando ativo
                        ),
                      );
                    }),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          SetValue(0);
                          funcao(elemento, 0);
                        },
                        child: Text(texto1!, style: TextStyle(fontSize: 11)))),
              ],
            ),
            Row(
              children: [
                //linha vertical 2
                Container(width: 20, height: 1, color: Colors.white),
                ValueListenableBuilder(
                    valueListenable: isCheckedNotifier2,
                    builder: (context, isChecked, child) {
                      return SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: isChecked,

                          onChanged: (bool? value) {
                            SetValue(1);
                            funcao(elemento, 1);
                          },
                          shape: CircleBorder(), // Transforma em círculo
                          side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  )), // Borda branca
                          checkColor:
                              Colors.transparent, // Cor da marca de seleção
                          activeColor:
                              Colors.green, // Preenchimento quando ativo
                        ),
                      );
                    }),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          SetValue(1);
                          funcao(elemento, 1);
                        },
                        child: Text(texto2!, style: TextStyle(fontSize: 11)))),
              ],
            ),
            Row(
              children: [
                //linha vertical 3
                Container(width: 30, height: 1, color: Colors.white),
                ValueListenableBuilder(
                    valueListenable: isCheckedNotifier3,
                    builder: (context, isChecked, child) {
                      return SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: isChecked,

                          onChanged: (bool? value) {
                            SetValue(2);
                            funcao(elemento, 2);
                          },
                          shape: CircleBorder(), // Transforma em círculo
                          side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  )), // Borda branca
                          checkColor:
                              Colors.transparent, // Cor da marca de seleção
                          activeColor:
                              Colors.green, // Preenchimento quando ativo
                        ),
                      );
                    }),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          SetValue(2);
                          funcao(elemento, 2);
                        },
                        child: Text(texto3!, style: TextStyle(fontSize: 11)))),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

AdicionarCargo(context) {
  var udb = User_Database();
  String? titulo;
  Map<String, int> Valores = {
    'Produtos': 0,
    'Clientes': 0,
    'Sistema': 0,
    'Revendedoras': 0,
    'Financeiro': 0,
  };
  DefineValor(String elemento, int valor) {
    Valores[elemento] = valor;
  }

  cria_cargo() {
    udb.MakeRole(
        nome: titulo,
        clientes: Valores['Clientes'],
        produtos: Valores['Produtos'],
        sistema: Valores["Sistema"],
        revendedoras: Valores['Revendedoras'],
        financeiro: Valores['Financeiro']);
  }

  return showDialog(
      context: context,
      barrierDismissible: false, // Impede fechar ao tocar fora
      builder: (context) {
        return Center(
          child: Container(
            // borda
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 2),
            ),
            // tamanho da janela
            height: MediaQuery.of(context).size.height * 0.70,
            width: MediaQuery.of(context).size.width * 0.70,
            // ClipRRect para os widgets internos não sobreporem a borda arredondada
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Scaffold(
                appBar: AppBar(
                  // botão para fechar a janela
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close)),
                  surfaceTintColor: Colors.black,
                ),
                // coluna principal
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (texto) => titulo = texto,
                          maxLength: 20,
                        ),
                        selectrow(
                            context: context,
                            titulo: 'Produtos',
                            elemento: 'Produtos',
                            texto1:
                                'Visualizar apenas produtos em estoque ou que já foram vendidos por esse usuário',
                            texto2: 'Visualizar todos os produtos cadastrados',
                            texto3: 'Criar/Editar produtos',
                            funcao: DefineValor,
                            valor: Valores['Produtos']),
                        selectrow(
                            context: context,
                            titulo: 'Clientes',
                            elemento: 'Clientes',
                            texto1:
                                'Visualizar apenas os clientes criados por esse usuário',
                            texto2: 'Visualizar todos os clientes cadastrados',
                            texto3: 'Editar qualquer cliente',
                            funcao: DefineValor,
                            valor: Valores['Clientes']),
                        selectrow(
                            context: context,
                            titulo: 'Sistema',
                            elemento: 'Sistema',
                            texto1: 'Nenhum acesso às configurações do sistema',
                            texto2: 'Indefinido',
                            texto3: 'Pode alterar as configurações do sistema',
                            funcao: DefineValor,
                            valor: Valores['Sistema']),
                        selectrow(
                            context: context,
                            titulo: 'Revendedoras',
                            elemento: 'Revendedoras',
                            texto1:
                                'Nenhum acesso aos cadastros dos outros revendedores',
                            texto2:
                                'Pode visualizar os cadastros dos outros revendedores',
                            texto3:
                                'Pode Criar/Editar cadastros dos outros revendedores',
                            funcao: DefineValor,
                            valor: Valores['Revendedoras']),
                        selectrow(
                            context: context,
                            titulo: 'Financeiro',
                            elemento: 'Financeiro',
                            texto1:
                                'Acesso à apenas informações financeiras próprias',
                            texto2:
                                'Acesso à informações financeiras da empresa',
                            texto3:
                                'Acesso à informações financeiras de outros usuarios',
                            funcao: DefineValor,
                            valor: Valores['Financeiro']),
                        TextButton(
                            onPressed: () => cria_cargo(),
                            child: Text('Parede')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
