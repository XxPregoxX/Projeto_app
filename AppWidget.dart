import 'package:experimentos/AddProduct.dart';
import 'package:experimentos/Add_Seller.dart';
import 'package:experimentos/Configura%C3%A7%C3%B5es.dart';
import 'package:experimentos/Loading.dart';
import 'package:experimentos/Login.dart';
import 'package:experimentos/Product.dart';
import 'package:experimentos/Revendedoras.dart';
import 'package:experimentos/Scaner.dart';
import 'package:experimentos/Products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Customers.dart';
import 'DataBase.dart';
import 'Functions.dart';
import 'HomePage.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  dynamic routes = {
    '/Home': (context) => HomePage(),
    '/QRcode': (context) => Scaner(),
    '/Storage': (context) => Storage(),
    '/Customers': (context) => Customers(),
    '/Login': (context) => LoginPage(),
    '/addProduct': (context) => AddProductScreen(),
    '/Product': (context) => Product(),
    '/Sellers': (context) => Sellers(),
    '/AddSeller': (context) => AddSeller(),
    '/Settings': (context) => Config(),
  };
  dynamic theme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[300], // Cor principal para textos e ícones claros
    scaffoldBackgroundColor: Colors.black, // Fundo preto
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black, // Cor de fundo da SnackBar
      contentTextStyle: TextStyle(color: Colors.white), // Estilo do texto
    ),
    // AppBar com fundo preto e texto claro
    appBarTheme: AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.grey[300], // Ícones no app bar mais claros
      ),
      titleTextStyle: TextStyle(
        color: Colors.grey[300], // Título do app bar claro
        fontSize: 20,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // Usamos o FutureBuilder para esperar a resposta da função assíncrona
    return MaterialApp(
      routes: routes,
      theme: theme,
      home: FutureBuilder<bool>(
        future: VerifyInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else if (snapshot.hasData && snapshot.data == true) {
            // Usuário está logado, redirecionar para a Home
            return HomePage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
