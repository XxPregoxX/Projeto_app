import 'dart:io';
import 'dart:typed_data';

import 'package:experimentos/Functions.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MyWidgets {
  InputDecoration halfInputText(String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: Color.fromARGB(156, 255, 125, 253)),
      enabledBorder: const OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderSide: const BorderSide(
            color: Color.fromARGB(99, 246, 195, 255), width: 1),
      ),
    );
  }

  DisplayContainer(
      {BuildContext? context, Widget? column, double? Height, double? Width}) {
    Height ??= MediaQuery.of(context!).size.height * 0.70;
    Width ??= MediaQuery.of(context!).size.width * 0.43;
    return Container(
      width: Width,
      height: Height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
      ),

      // Coluna direita
      child: column,
    );
  }

  Rowidget(
      {BuildContext? context, Widget? column, double? Height, double? Width}) {
    Height ??= MediaQuery.of(context!).size.height * 0.05;
    Width ??= MediaQuery.of(context!).size.width * 0.425;
    return Container(
      width: Width,
      height: Height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
      ),

      // Coluna direita
      child: column,
    );
  }

  TextStyle Labels() {
    return TextStyle(fontSize: 12);
  }

  TextStyle Values() {
    return TextStyle(fontSize: 11);
  }

  OutlinedButton button(String text, onpressed) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        // Cor de fundo do botão
        side: BorderSide(
            width: 1.0,
            color: const Color.fromARGB(
                101, 224, 19, 255)), // Cor de fundo do botão

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Borda arredondada
        ),
      ),
      onPressed: onpressed,
      child: Text(text,
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 107, 253), // Cor do texto
            fontWeight: FontWeight.bold,
            fontSize: 16, // Tamanho da fonte),
          )),
    );
  }

  infoPopup(context, String text, {int duration = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior
            .floating, // Deixa o SnackBar flutuante // Fundo preto semi-transparente
        content: Center(child: Text(text)),
        duration: Duration(seconds: duration),
      ),
    );
  }
}

// Função para configurar o tema do crop
List<PlatformUiSettings> CropperTheme(BuildContext context) {
  return [
    // Configuração para Android
    AndroidUiSettings(
      toolbarTitle: 'Editar Imagem',
      toolbarColor: Colors.black, // Cor de fundo do toolbar
      toolbarWidgetColor: Colors.white, // Cor dos ícones/textos
      backgroundColor: Colors.black, // Cor de fundo
      activeControlsWidgetColor:
          const Color.fromARGB(255, 199, 199, 199), // Cor dos controles ativos
      statusBarColor: Colors.black, // Cor da status bar
      cropFrameColor: Colors.grey, // Cor da moldura de recorte
      cropGridColor: Colors.grey, // Cor da grade
      dimmedLayerColor: const Color.fromARGB(114, 0, 0, 0),
      showCropGrid: true, // Mostrar ou ocultar a grade
      lockAspectRatio: false, // Bloqueia a proporção do recorte
    ),
  ];
}
