import 'package:experimentos/Cargos.dart';
import 'package:experimentos/DataBase.dart';
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
        body: Row(
          children: [
            TextButton(
              child: Text('caraio'),
              onPressed: () {
                AdicionarCargo(context);
              },
            ),
            ElevatedButton(
                onPressed: () => pickLogo(), child: Text('Change logo'))
          ],
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
