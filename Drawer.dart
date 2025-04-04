import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MainDrawer extends StatelessWidget {
  String? page;
  MainDrawer({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: MediaQuery.of(context).size.width / 1.7,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.zero, bottomRight: Radius.zero),
        ),
        backgroundColor: const Color.fromARGB(207, 0, 0, 0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
                decoration: const BoxDecoration(
              color: Colors.white,
            )),
            // pagina inicial
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Home');
              },
              // Verifica a pagina e deixa o nome dela em negrito no drawer.
              title: page == 'home'
                  ? const Text(
                      'Home',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text('Home'),
            ),
            // pagina de produtos.
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Storage');
              },
              // Verifica a pagina e deixa o nome dela em negrito no drawer.
              title: page == 'storage'
                  ? const Text(
                      'Catálogo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text('Catálogo'),
            ),
            // pagina de clientes
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Customers');
              },
              // Verifica a pagina e deixa o nome dela em negrito no drawer.
              title: page == 'customers'
                  ? const Text(
                      'Clientes',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text('Clientes'),
            ),
            // pagina de revendedores
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Sellers');
              },
              // Verifica a pagina e deixa o nome dela em negrito no drawer.
              title: page == 'sellers'
                  ? const Text(
                      'Revendedores',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text('Revendedores'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Settings');
              },
              // Verifica a pagina e deixa o nome dela em negrito no drawer.
              title: page == 'settings'
                  ? const Text(
                      'Configurações',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text('Configurações'),
            ),
          ],
        ),
      ),
    );
  }
}
