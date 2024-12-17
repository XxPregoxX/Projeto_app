import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:experimentos/DataBase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'Decoration.dart';
import 'Functions.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _price1Controller = TextEditingController();
  final TextEditingController _price2Controller = TextEditingController();
  final decoration = Widgets();
  File? _selectedImage;
  String? _produto;
  String? _custo;
  String? _preco;

  final ImagePicker _picker = ImagePicker();

  // Função para pegar uma imagem

  void _pickImage() {
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
                  pickedFile = await cropIMG(context, pickedFile);

                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  } else {
                    decoration.infoPopup(
                        context, 'Nenhuma imagem selecionada.');
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
                  pickedFile = await cropIMG(context, pickedFile);

                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  } else {
                    decoration.infoPopup(context, 'Nenhuma imagem capturada.');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  addProduct() async {
    List missing = [];
    final db = ProductDatabase();
    // converte a imagem em bytes
    Uint8List _convertedImage = await _selectedImage!.readAsBytes();
    // pega o tamanho da imagem em bytes
    dynamic img_size = (_convertedImage.lengthInBytes);
    // verifica se todos os campos foram preenchidos e se a imagem tem menos de 5MB.
    if (_selectedImage != null &&
        _custo != null &&
        _preco != null &&
        _produto != null &&
        img_size < 5e+6) {
      // Converte os dinheiros para double
      double _convertedCost = double.parse(_custo!.replaceAll(',', '.'));
      double _convertedPrice = double.parse(_preco!.replaceAll(',', '.'));
      // adiciona o produto na database
      db.insertProduct(
          _convertedImage, _produto!, _convertedCost, _convertedPrice);
      Navigator.of(context).pop();
    } else {
      // adiciona na mensagem se falta imagem
      if (_selectedImage == null && missing.contains('Imagem') == false) {
        missing.add('Imagem');
      }
      // adiciona na mensagem se falta Custo
      if (_custo == null && missing.contains('Custo') == false) {
        missing.add('Custo');
      }
      // adiciona na mensagem se falta Preço
      if (_preco == null && missing.contains('Preço') == false) {
        missing.add('Preço');
      }
      // adiciona na mensagem se falta Nome do produto
      if (_produto == null && missing.contains('Nome do produto') == false) {
        missing.add('Nome do produto');
      }
      // Mensagem se a imagem tem mais de 5MB
      if (img_size > 5e+6) {
        decoration.infoPopup(
            context, 'Imagem muito pesada, imagens devem ter menos de 5 MB',
            duration: 5);
      }
    }

    //mensagem com tudo que ta faltando
    String formated = missing.join(', ');
    decoration.infoPopup(context,
        'Não foi possível salvar, falta preencher os campos: $formated',
        duration: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Campo de imagem
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: _selectedImage == null
                      ? Center(child: Text('Selecionar Imagem'))
                      : Image.file(_selectedImage!, fit: BoxFit.fitHeight),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                // Campo de nome
                child: TextField(
                    onChanged: (value) => _produto = value,
                    controller: _nameController,
                    decoration: decoration.halfInputText('Nome do Produto'),
                    maxLength: 10),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campo de preço 1
                  SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.35) - 7.5,
                    child: TextField(
                      onChanged: (value) => _custo = value,
                      controller: _price1Controller,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: decoration.halfInputText('Custo'),
                      maxLength: 8,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(
                            r'^\d*[.,]?\d{0,2}$')), // Aceita apenas dígitos
                      ],
                    ),
                  ),
                  SizedBox(width: 15.0),

                  // Campo de preço 2
                  SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.35) - 7.5,
                    child: TextField(
                      onChanged: (value) => {
                        _preco = value,
                        TextEditingController().value = TextEditingValue(
                          text: value.replaceAll(',', '.'),
                          selection:
                              TextSelection.collapsed(offset: value.length),
                        )
                      },
                      controller: _price2Controller,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: decoration.halfInputText('Preço'),
                      maxLength: 8,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(
                            r'^\d*[.,]?\d{0,2}$')), // Aceita apenas dígitos
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: decoration.button('Confirmar', () => addProduct()))
            ],
          ),
        ),
      ),
    );
  }
}
