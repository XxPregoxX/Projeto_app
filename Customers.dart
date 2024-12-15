import 'package:experimentos/Functions.dart';
import 'package:experimentos/DataBase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'Drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  String name = '';
  String number = '';
  List listnames = [];
  List filteredItems = [];
  String previousText = "";
  Future<void>? _refresh;
  Uint8List? _logo;
  final db = ClientDatabase();

  Future<void> refresh() async {
    List<Map<String, dynamic>> clients = await db.getClients();
    listnames = [];

    clients.forEach((doc) {
      listnames.add([doc['name'], doc[('phone')], doc['id']]);
    });
    Uint8List logo = await Logo().displayLogo();
    if (mounted) {
      setState(() {
        filteredItems = pegarPrimeirosValores(listnames);
        _logo = logo;
      });
    }
  }

  void _filterItems(String search) {
    List results = [];
    if (search.isEmpty) {
      results = pegarPrimeirosValores(
          listnames); // Se a pesquisa estiver vazia, mostrar todos os itens
    } else {
      results = pegarPrimeirosValores(listnames)
          .where((item) =>
              item.toLowerCase().contains(search.toLowerCase())) // Filtrar
          .toList();
    }

    setState(() {
      filteredItems = results;
      previousText = search;
    });
  }

  @override
  void initState() {
    super.initState();
    // Função chamada uma única vez na inicialização
    _refresh = refresh();
  }

  @override
  Widget build(BuildContext context) {
    // widget pai
    return Scaffold(
      //safearea para manter o app abaixo da barra de aplicativo do celular
      body: SafeArea(
          //scaffold que propriamente mantém a estrutura do app
          child: Scaffold(
        //appbar da pagina
        appBar: AppBar(
          title: TextField(
            decoration: const InputDecoration(
              hintText: 'Pesquisar',
              suffixIcon: Icon(Icons.search), // Ícone à direita
            ),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: (search) {
              _filterItems(search);
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          actions: [
            FutureBuilder(
                future: _refresh,
                builder: (context, load) {
                  if (load.connectionState == ConnectionState.waiting) {
                    return Text('carregando');
                  } else if (_logo != null) {
                    return Image.memory(_logo!, fit: BoxFit.cover);
                  } else {
                    return Text('logo');
                  }
                })
          ],
        ),
        // drawer da pagina
        drawer: MainDrawer(page: 'customers'),
        body: FutureBuilder<void>(
          future: _refresh,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Enquanto o futuro está em andamento, exibe o CircularProgressIndicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // Se houve um erro, exibe uma mensagem de erro
              return const Center(child: Text('Erro ao carregar dados.'));
            } else if (filteredItems.isEmpty) {
              // Se não há itens, exibe uma mensagem
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Você ainda não cadastrou nenhum cliente.',
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              // Quando os dados estiverem prontos, exibe a lista
              return ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: Colors.black,
                    title: Text(filteredItems[index]),
                    subtitle: Text(PhoneNumber(number: listnames[index][1])),
                    onLongPress: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Excluir Item'),
                          content: const Text(
                              'Você tem certeza que deseja excluir este item?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pop(false), // Não excluir
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                db.deleteClient(listnames[index][2]);
                                refresh();
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Item excluído com sucesso.')),
                        );
                      }
                    },
                    trailing: InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        WhatsApp(number: listnames[index][1], context: context);
                      },
                      child: const Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (text) {
                          name = text;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Nome"),
                      ),
                      TextField(
                        onChanged: (text) {
                          number = text;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly, // Aceita apenas dígitos
                        ],
                        maxLength: 11,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: const InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(),
                            labelText: "Número"),
                      ),
                      TextButton(
                          onPressed: () {
                            if (name.isNotEmpty && number.length == 11) {
                              db.insertClient({
                                "id": Uuid().v1(),
                                "name": name,
                                "phone": number,
                                "synced": 0
                              });
                              refresh();
                              Navigator.pop(context);
                              syncIfConnected();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Número invalido')));
                            }
                          },
                          child: const Text('Adicionar'))
                    ],
                  ),
                );
              },
            );
          },
          shape: CircleBorder(),
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      )),
    );
  }
}
