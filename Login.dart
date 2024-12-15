import 'package:experimentos/Functions.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores de texto para email e senha
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscured = true; // Define o estado inicial do campo como oculto
  String email = '';
  String senha = '';
  bool _isLoading = false; // Estado para controlar o carregamento

  Future<void> _login(String Email, String Senha, context) async {
    setState(() {
      _isLoading = true; // Começa o carregamento
    });
    verifyLogin(email, senha, context);
    setState(() {
      _isLoading = false; // Para o carregamento
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),

              // Título centralizado
              Center(
                child: Text(
                  'Bem-vindo!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 40),

              // Campo de texto para email
              TextField(
                onChanged: (text) {
                  email = text;
                },
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de texto para senha
              TextField(
                onChanged: (text) {
                  senha = text;
                },
                controller: passwordController,
                obscureText: _isObscured,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured =
                            !_isObscured; // Alterna entre mostrar e esconder a senha
                      });
                    },
                  ),
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botão de login com estilo
              // Placeholder para função de login
              _isLoading
                  ? CircularProgressIndicator() // Mostra o carregador
                  : ElevatedButton(
                      onPressed: () {
                        _login(email, senha, context);
                      }, // Chama a função de login

                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
              const SizedBox(height: 20),

              // Botão de recuperação de senha
              TextButton(
                onPressed: () {
                  // Placeholder para função de recuperação de senha
                },
                child: const Text('Esqueci a senha'),
              ),

              const SizedBox(height: 40),

              // Rodapé com opção de cadastro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Não tem uma conta?"),
                  TextButton(
                    onPressed: () {
                      // Placeholder para redirecionamento de cadastro
                    },
                    child: const Text('Cadastre-se'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
