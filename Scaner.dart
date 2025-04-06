import 'dart:typed_data';

import 'package:experimentos/DataBase.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scaner extends StatefulWidget {
  @override
  State<Scaner> createState() {
    return ScanerState();
  }
}

Future QRprocess(id, context) async {
  int id_int = int.parse(id);
  var db = ProductDatabase();
  bool verify = await db.verifyId(id_int);
  if (verify == true) {
    print('ai caraio' + id);
    Navigator.of(context)
        .pushReplacementNamed('/Product', arguments: {"productId": id_int});
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return Text(id! + "não é um ID valido");
        });
  }
}

class ScanerState extends State<Scaner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: MobileScanner(
      controller: MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        returnImage: true,
      ),
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        // fazer uma verificação de ID depois
        QRprocess(barcodes.first.rawValue, context = context);
      },
    )));
  }
}
