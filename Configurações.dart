import 'package:experimentos/Decoration.dart';
import 'package:experimentos/Drawer.dart';
import 'package:flutter/material.dart';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Scaffold(
        body: TextButton(
          child: Text('caraio'),
          onPressed: () {
            AdicionarCargo(context);
          },
        ),
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
        drawer: MainDrawer(page: 'settings'),
      )),
    );
  }
}
