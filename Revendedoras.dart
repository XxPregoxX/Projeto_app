import 'dart:convert';

import 'package:experimentos/Add_Seller.dart';
import 'package:experimentos/DataBase.dart';
import 'package:experimentos/Functions.dart';
import 'package:flutter/material.dart';
import 'Decoration.dart';
import 'Drawer.dart';

class Sellers extends StatefulWidget {
  @override
  State<Sellers> createState() {
    return SellersState();
  }
}

class SellersState extends State<Sellers> {
  var wd = MyWidgets();
  dynamic vendas;
  String? id;
  Map produtos = {};

  addseller() async {
    await Navigator.of(context).pushNamed('/AddSeller');
    setState(() {});
  }

  getInfo() async {
    vendas = await User().getSells();

    for (var venda in vendas) {
      var product = await User().getProduct(venda['productID']);
      await produtos.putIfAbsent(venda['id'], () => product[0]);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              })),

          // Centraliza o container da cluna principal
          body: Center(
            // Container para limitar a coluna principal
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              // Coluna principal
              child: Column(
                children: [
                  // Primeira metade da tela
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                    children: [
                      // Foto revendedora
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          height: MediaQuery.of(context).size.width * 0.26,
                        ),
                      ),
                      // Info revendedora
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nome',
                          ),
                          Text(
                            'CPF',
                          ),
                          Text(
                            'Contato',
                          ),
                          Text(
                            'e-mail',
                          ),
                          Text(
                            'Cargo',
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  // Segunda metade da tela
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Coluna esquerda
                        Column(
                          spacing: MediaQuery.of(context).size.height * 0.01,
                          children: [
                            wd.DisplayContainer(
                                context: context,
                                Height:
                                    MediaQuery.of(context).size.height * 0.345,
                                column: Column(
                                  children: [Text('Ganhos')],
                                )),
                            wd.DisplayContainer(
                                context: context,
                                Height:
                                    MediaQuery.of(context).size.height * 0.345,
                                column: Column(
                                  children: [Text('Comissão')],
                                )),
                          ],
                        ),

                        // Coluna direita
                        wd.DisplayContainer(
                            context: context,
                            column: Column(
                              children: [
                                Text('teste'),
                                // Linha divisória Titulo
                                Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                  height: 2,
                                ),
                                FutureBuilder(
                                    future: getInfo(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text('Carregando');
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Expanded(
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemCount: vendas.length,
                                              itemBuilder: (context, index) {
                                                Map row = vendas[index];
                                                String Sellid = row['id'];

                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image.memory(
                                                          produtos[Sellid]
                                                              ['image'],
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.23,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.23,
                                                        ),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.01),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                produtos[Sellid]
                                                                    ['name']),
                                                            Text('Lucro:',
                                                                style: wd
                                                                    .Labels()),
                                                            Text(
                                                                ' ${formatCurrency(row['lucro'])}',
                                                                style: wd
                                                                    .Values()),
                                                            Text('Receita:',
                                                                style: wd
                                                                    .Labels()),
                                                            Text(
                                                              ' ${formatCurrency(row['receita'])}',
                                                              style:
                                                                  wd.Values(),
                                                            ),
                                                            Text(
                                                                "Vendidos: ${row['quantidade']}",
                                                                style: wd
                                                                    .Labels()),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    // Linha divisória
                                                    Divider(
                                                      color: Colors.white,
                                                      thickness: 2,
                                                      height: 2,
                                                    )
                                                  ],
                                                );
                                              }),
                                        );
                                      } else {
                                        return Text('Erro');
                                      }
                                    })
                              ],
                            ))
                      ])
                ],
              ),
            ),
          ),
          drawerScrimColor: Colors.transparent,
          drawer: MainDrawer(
            page: 'sellers',
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              addseller();
            },
            shape: CircleBorder(),
            child: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
