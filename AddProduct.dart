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

  TextEditingController _controller = TextEditingController();
  final decoration = Widgets();
  File? _imageFile;
  String? _produto;
  String? _custo;
  String? _preco;
  int quantity = 1;
  Uint8List? _selectedImage;
  String? imageSize;

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
                  _imageFile = File(pickedFile.path);
                  _selectedImage = await _imageFile!.readAsBytes();

                  if (pickedFile != null) {
                    setState(() {
                      imageSize = formatFileSize(_selectedImage!.length);
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
                  _imageFile = File(pickedFile.path);
                  _selectedImage = await _imageFile!.readAsBytes();

                  if (pickedFile != null) {
                    setState(() {
                      imageSize = formatFileSize(_selectedImage!.length);
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
    // pega o tamanho da imagem em bytes
    dynamic img_size = (_selectedImage!.lengthInBytes);
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
      db.insertProduct(_selectedImage!, _produto!, _convertedCost,
          _convertedPrice, quantity);
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
      //mensagem com tudo que ta faltando
      String formated = missing.join(', ');
      decoration.infoPopup(context,
          'Não foi possível salvar, falta preencher os campos: $formated',
          duration: 5);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.text = quantity.toString();
  }

  void _updateQuantity(int newQuantity) {
    setState(() {
      quantity = newQuantity;
      _controller.text = quantity.toString();
    });
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
                  height: MediaQuery.of(context).size.height * 0.43,
                  width: MediaQuery.of(context).size.height * 0.43,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 147, 51, 185), width: 3),
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
              ),
              imageSize == null
                  ? SizedBox(height: 5)
                  : Container(
                      width: MediaQuery.of(context).size.height * 0.39,
                      child: Text(
                        style: TextStyle(fontSize: 10),
                        imageSize!,
                        textAlign: TextAlign.start,
                      ),
                    ),
              SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                height: MediaQuery.of(context).size.height * 0.09,
                // Campo de nome
                child: TextField(
                  onChanged: (value) => _produto = value,
                  controller: _nameController,
                  decoration: decoration.halfInputText('Nome do Produto'),
                  maxLength: 10,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campo de preço 1
                  SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.35) - 7.5,
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: TextField(
                      onChanged: (value) => _custo = value,
                      controller: _price1Controller,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: decoration.halfInputText('Custo'),
                      maxLength: 8,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                    height: MediaQuery.of(context).size.height * 0.09,
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
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(
                            r'^\d*[.,]?\d{0,2}$')), // Aceita apenas dígitos
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text('Saldo de estoque:'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      if (quantity > 0) _updateQuantity(quantity - 1);
                    },
                    icon: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        // Remove a linha de baixo
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      maxLength: 2,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onSubmitted: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed != null && parsed >= 0) {
                          _updateQuantity(parsed);
                        } else {
                          _controller.text = quantity.toString();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _updateQuantity(quantity + 1);
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: decoration.button('Confirmar', () => addProduct()))
            ],
          ),
        ),
      ),
    );
  }
}
