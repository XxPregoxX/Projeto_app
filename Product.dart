import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:experimentos/DataBase.dart';
import 'package:experimentos/Functions.dart';
import 'package:experimentos/Loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  String? productId;
  Map? data;
  String? profitpercent;
  double? profit;
  dynamic fileSize;
  double? comission;
  double? comissionPercentage;
  double? price;
  double? cost;
  String? id;
  int? vendidos;
  final db = ProductDatabase();

  Sell() {
    db.SellProduct(data!['id'], 'stock', data!['stock'] - 1);
    User_Database().insertSell(
        comissao: comission, productID: id, receita: price, lucro: profit);
    setState(() {});
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    productId = args['productId'] ?? 'Produto inexistente';

    data = await db.getbyid(productId);
    vendidos = await User_Database().getTotalQuantidade(productId!);
    price = data!['price'];
    cost = data!['cost'];
    id = data!["id"].toString();
    profitpercent = formatPercentage(((price! * 100) / cost!) - 100);
    profit = price! - cost!;
    comissionPercentage = await User_Database().getComission();
    comission = price! * comissionPercentage!;

    // Obtenha os metadados do arquivo
    fileSize = formatFileSize(data!['image'].lengthInBytes);
    print(UserDataCache.Cargo);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: didChangeDependencies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LoadingScreen());
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(data!['name']),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Imagem do Produto
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.memory(
                        data!['image'],
                        height: MediaQuery.of(context).size.width * 0.80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                    // Informações do Produto
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ID: ${id}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text("Custo de compra",
                                        style: TextStyle(color: Colors.grey)),
                                    Text(formatCurrency(cost!),
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("Preço de venda",
                                        style: TextStyle(color: Colors.grey)),
                                    Text(formatCurrency(price!),
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Estoque: ${data!['stock']}",
                                        style: TextStyle(fontSize: 16)),
                                    Text("Vendidos: $vendidos",
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Lucro: ${formatCurrency(profit!)}",
                                        style: TextStyle(fontSize: 16)),
                                    Text("Margem: $profitpercent",
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ],
                            ), // ajustar campo depois

                            Text("Comissão: ${formatCurrency(comission!)}",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),

                    // Botão de Vender
                    ElevatedButton.icon(
                      onPressed: () {
                        // Lógica de venda
                        Sell();
                        print("Vender produto");
                      },
                      icon: Icon(Icons.shopping_cart),
                      label: Text("Vender Produto"),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Text("Produto inválido");
        }
      },
    );
  }
}
