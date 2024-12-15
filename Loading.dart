import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String? message; // Texto opcional para exibir na tela de carregamento

  LoadingScreen({this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 20), // Espaço entre o indicador e o texto
            if (message != null) // Exibe a mensagem, se fornecida
              Text(
                message!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
