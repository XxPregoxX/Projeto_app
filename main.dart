import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'AppWidget.dart';
import 'package:experimentos/DataBase.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? user = await FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Busca os dados apenas se o usuário já estiver logado
    await User_Database().carregarDadosDoUsuario();
  }
  runApp(AppWidget());
}
