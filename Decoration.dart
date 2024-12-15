import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class Widgets {
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
