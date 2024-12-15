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
  String? profit;
  dynamic fileSize;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    productId = args['productId'] ?? 'Produto inexistente';

    data = await ProductDatabase().getbyid(productId);
    ;
    // Obtenha os metadados do arquivo
    fileSize = formatFileSize(data!['image'].lengthInBytes);
  }

  void Profit() {
    // TODO: implement initState
    profit = formatPercentage(((data!['price'] * 100) / data!['cost']) - 100);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: didChangeDependencies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingScreen()); // Exibe um indicador de carregamento
          } else if (snapshot.connectionState == ConnectionState.done) {
            Profit();
            return Scaffold(
              appBar: AppBar(
                title: Text(data!['name']),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Image.memory(
                    data!['image'],
                    height: MediaQuery.of(context).size.width * 0.65,
                  ),
                  SizedBox(height: 30.0),
                  Text("ID: " + data!["id"].toString()),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("Custo de compra: "),
                          Text(formatCurrency(data!['price'])),
                        ],
                      ),
                      SizedBox(width: 15.0),
                      Column(
                        children: [
                          Text("Preço de venda: "),
                          Text(formatCurrency(data!['price']))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  // ajustar depois,
                  Text('Proprietario: ' + data!['owner']),
                  SizedBox(height: 30.0),
                  Text(profit!),
                  Text('Tamanho: ' + fileSize!),
                ],
              ),
            ); // Exibe erros, se houver
          } else {
            return Text("Produto invalido");
          }
        });
  }
}
