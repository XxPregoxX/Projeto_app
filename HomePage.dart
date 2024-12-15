import 'package:experimentos/Scaner.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'Drawer.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
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
          body: Text(''),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              //Navigator.of(context).pushNamed('/QRcode');
              // fazer uma verificação de ID depois
              Navigator.of(context).pushNamed('/QRcode');
            },
            shape: CircleBorder(),
            child: const Icon(
              Icons.qr_code_2,
              size: 40,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          drawerScrimColor: Colors.transparent,
          drawer: MainDrawer(
            page: 'home',
          ),
        ),
      ),
    );
  }
}
