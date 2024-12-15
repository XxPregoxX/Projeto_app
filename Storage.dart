import 'package:experimentos/DataBase.dart';
import 'package:experimentos/Functions.dart';
import 'package:flutter/material.dart';
import 'Drawer.dart';
import 'DataBase.dart';

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _CustomersState();
}

class _CustomersState extends State<Storage> {
  List list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future Reload() async {
    dynamic Products = await ProductDatabase().getImages();
    list = [];
    if (Products != null) {
      await Products.forEach((c) => list.add(c));
    }
  }

  Addimage() async {
    await Navigator.of(context).pushNamed('/addProduct');
    await Reload();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Scaffold(
        body: FutureBuilder(
            future: Reload(),
            builder: (context, load) {
              if (load.connectionState == ConnectionState.waiting) {
                return Text('carregando');
              } else if (list.isNotEmpty) {
                return GridView.count(
                  crossAxisCount: 3, // Número de colunas
                  crossAxisSpacing: 10, // Espaçamento horizontal entre itens
                  mainAxisSpacing: 10, // Espaçamento vertical entre itens
                  padding: EdgeInsets.all(10), // Padding ao redor da grade
                  children: list.map((product) {
                    return GridTile(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/Product',
                              arguments: {"productId": product[1]});
                        },
                        child: Column(
                          children: [
                            Expanded(
                                child: Image.memory(product[0],
                                    fit: BoxFit.scaleDown)),
                            Text(
                              product[2],
                            ),
                            Text(
                              formatCurrency(product[3]),
                              selectionColor:
                                  Color.fromARGB(255, 233, 227, 227),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Text("Não tem produto");
              }
            }),
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
        drawer: MainDrawer(page: 'storage'),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Addimage();
        },
        shape: CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
