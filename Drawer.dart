import 'package:experimentos/DataBase.dart';
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
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Home');
              },
              title: page == 'home'
                  ? const Text(
                      'Home',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text('Home'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Storage');
              },
              title: page == 'storage'
                  ? const Text(
                      'Catálogo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text('Catálogo'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Customers');
              },
              title: page == 'customers'
                  ? const Text(
                      'Clientes',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text('Clientes'),
            ),
            ListTile(
              onTap: () {
                pickLogo();
              },
              title: Text('Change Logo'),
            ),
          ],
        ),
      ),
    );
  }
}
