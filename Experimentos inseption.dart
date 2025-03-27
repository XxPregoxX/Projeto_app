import 'package:flutter/material.dart';

product_split(String texto) {
  var pipeSplit = texto.split('|');
  print(pipeSplit);
  pipeSplit.forEach((product) {
    print(product.split(','));
  });
}
