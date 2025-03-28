import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:experimentos/DataBase.dart';
import 'package:experimentos/Decoration.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

PhoneNumber({required String number}) {
  String Formated =
      '(${number.substring(0, 2)}) ${number.substring(2, 3)}${number.substring(3, 7)}-${number.substring(7, 11)}';
  return Formated;
}

WhatsApp({required String number, required context}) async {
  String CleanNumber = number.replaceAll(RegExp(r'\D'), '');
  String FinalNumber = '55' + CleanNumber;
  final Uri url = Uri.parse('https://wa.me/$FinalNumber');
  try {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } on Exception {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Não foi possível localizar este número')));
  }
}

List<dynamic> pegarPrimeirosValores(List<dynamic> listaDeListas) {
  List<dynamic> primeiros = [];

  for (var sublista in listaDeListas) {
    if (sublista is List && sublista.isNotEmpty) {
      primeiros.add(sublista.first);
    }
  }

  return primeiros;
}

DeleteItem({required itemId}) async {
  await Firebase.initializeApp();
  FirebaseFirestore db = FirebaseFirestore.instance;
  await db
      .collection('/Cadastros/Luana/Revendedoras/Leonardo Borges/Clientes')
      .doc(itemId)
      .delete();
}

Future<void> Register(String Email, String Senha) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: Email, password: Senha);
}

Future<void> verifyLogin(String email, String senha, context) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult[0] != ConnectivityResult.none) {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha);
    if (FirebaseAuth.instance.currentUser != null) {
      await User_Database().carregarDadosDoUsuario();
      Navigator.of(context).pushNamed('/Home');
    }
  }
}

Future<bool> VerifyInstance() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  await Firebase.initializeApp();
  if (connectivityResult[0] != ConnectivityResult.none) {
    await FirebaseAuth.instance.currentUser?.reload();
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  } else if (FirebaseAuth.instance.currentUser != null) {
    return true;
  } else {
    return false;
  }
}

String formatCurrency(double value) {
  final NumberFormat formatter = NumberFormat.currency(
      locale: 'pt_BR', // Define o idioma como português do Brasil
      symbol: 'R\$' // Define o símbolo da moeda
      );
  return formatter.format(value);
}

String formatPercentage(double value) {
  return '${value.toStringAsFixed(2)}%';
}

Future<dynamic> cropIMG(context, image) async {
  // Passo 2: Cropar imagem
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: image.path,
    aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Proporção 1x1
    uiSettings: CropperTheme(context),
  );
  return croppedFile;
}

String formatFileSize(int bytes) {
  const List<String> units = ['B', 'KB', 'MB', 'GB', 'TB'];
  double size = bytes.toDouble();
  int unitIndex = 0;

  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex++;
  }

  return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
}
