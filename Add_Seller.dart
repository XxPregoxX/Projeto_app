import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:experimentos/DataBase.dart';
import 'package:experimentos/Functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:select_field/select_field.dart';
import 'Decoration.dart';

class AddSeller extends StatefulWidget {
  @override
  State<AddSeller> createState() {
    return AddSellerState();
  }
}

class AddSellerState extends State<AddSeller> {
  var wd = MyWidgets();
  File? _imageFile;
  Uint8List? _selectedImage;
  String? imageSize;
  final ImagePicker _picker = ImagePicker();
  String? email;
  String? password;
  String? name;
  String? cpf;
  String? phone;
  double? comissao;
  String? cargo;
  List<Option<dynamic>> options = [
    Option(label: 'Administrador', value: 'adm'),
    Option(label: 'Revendedor', value: 'user')
  ];

  Verify() async {
    String? erro = await User_Database().Add_user(
        email: email,
        password: password,
        number: phone,
        name: name,
        cpf: cpf,
        comission: comissao,
        role: cargo);
    if (erro != null) {
      wd.infoPopup(context, erro);
    }
  }

  _pickImage() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Escolher da Galeria'),
                onTap: () async {
                  Navigator.of(context).pop();
                  dynamic pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    pickedFile = await cropIMG(context, pickedFile);
                    _imageFile = File(pickedFile.path);
                    _selectedImage = await _imageFile!.readAsBytes();

                    setState(() {
                      imageSize = formatFileSize(_selectedImage!.length);
                    });
                  } else {
                    wd.infoPopup(context, 'Nenhuma imagem selecionada.');
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tirar Foto'),
                onTap: () async {
                  Navigator.of(context).pop();
                  dynamic pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    pickedFile = await cropIMG(context, pickedFile);
                    _imageFile = File(pickedFile.path);
                    _selectedImage = await _imageFile!.readAsBytes();

                    setState(() {
                      imageSize = formatFileSize(_selectedImage!.length);
                    });
                  } else {
                    wd.infoPopup(context, 'Nenhuma imagem capturada.');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              FormField(validator: (value) {
                if (_selectedImage == null) {
                  wd.infoPopup(context, 'Adicione uma imagem');
                }
                return null;
              }, builder: (state) {
                return GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.40,
                    width: MediaQuery.of(context).size.width * 0.40,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 255, 255, 255), width: 2),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _selectedImage == null
                        ? Center(child: Text('Selecionar Imagem'))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.memory(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                );
              }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    name = value;
                  },
                  decoration: wd.halfInputText('Nome'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um e-mail';
                    }
                    email = value;
                  },
                  decoration: wd.halfInputText('E-mail'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, adicione uma senha';
                    }
                    password = value;
                  },
                  decoration: wd.halfInputText('Senha'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um número de telefone';
                    }
                    phone = value;
                  },
                  decoration: wd.halfInputText('Número'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um CPF';
                    }
                    cpf = value;
                  },
                  decoration: wd.halfInputText('CPF'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um valor de comissão';
                    }
                    double number = double.parse(value) / 100;
                    comissao = number;
                  },
                  decoration: wd.halfInputText('Comissão'),
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: SelectField(
                    options: options,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira os privilegios';
                      }
                      cargo = value;
                    },
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    Verify();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    )));
  }
}
