import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class ClientDatabase {
  dynamic user = FirebaseAuth.instance.currentUser;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'local_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE clients (
            id TEXT PRIMARY KEY,
            name TEXT,
            phone TEXT UNIQUE,
            synced INTEGER
            history TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertClient(Map<String, dynamic> client) async {
    final db = await database;
    try {
      await db.insert('clients', client,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("Erro: o número já cadastrado."); // Ajustar depois
    }
  }

  Future<List<Map<String, dynamic>>> getClients() async {
    final db = await database;
    return await db.query('clients');
  }

  Future<void> deleteClient(String id) async {
    final db = await database;
    await db.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateClientSyncStatus(String id, int synced) async {
    final db = await database;
    await db.update('clients', {'synced': synced},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> syncClientsToFirebase() async {
    await Firebase.initializeApp();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String id = await user!.uid;
    final ClientDatabase _localDb = ClientDatabase();
    // Pegar os dados locais que não foram sincronizados (synced = 0)
    List<Map<String, dynamic>> unsyncedClients = await _localDb.getClients();

    // Para cada cliente não sincronizado, vamos enviá-lo ao Firestore
    for (var client in unsyncedClients) {
      if (client['synced'] == 0) {
        // campo temporario mudar "Luana para variavel de ususario ADM"
        await _firestore
            .collection('/Cadastros/Luana/Revendedoras/$id/Clientes')
            .doc(client['id'])
            .set({
          'name': client['name'],
          'phone': client['phone'],
        });

        // Após sincronizar, marcamos o cliente como sincronizado (synced = 1)
        await _localDb.updateClientSyncStatus(client['id'], 1);
      }
    }
  }
}

// remover depois
void printDatabase() async {
  // Crie uma instância da classe de gerenciamento do banco de dados local
  final db = ClientDatabase();
  // Obtenha todos os clientes salvos no banco
  List<Map<String, dynamic>> clients = await db.getClients();

  // Verifique se a lista está vazia
  if (clients.isEmpty) {
    print("O banco de dados está vazio.");
  } else {
    // Exiba cada cliente no console
    print("Conteúdo do banco de dados:");
    for (var client in clients) {
      print(
          "ID: ${client['id']}, Nome: ${client['name']}, Telefone: ${client['phone']}, Sincronizado: ${client['synced']}");
    }
  }
}

Future<void> syncDataFromFirebase() async {
  final ClientDatabase _localDb = ClientDatabase();

  // Alterar após terminar o resto do que será nescessário na database
  // Pega os dados do Firestore
  QuerySnapshot query =
      await FirebaseFirestore.instance.collection('clients').get();

  for (var doc in query.docs) {
    // Insere os dados no banco local
    await _localDb.insertClient({
      'id': doc.id,
      'name': doc['name'],
      'phone': doc['phone'],
      'synced': 1 // Marca como sincronizado
    });
  }
}

void syncIfConnected() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  // Alterar depois para buscar dados do firebase também
  if (connectivityResult[0] != ConnectivityResult.none) {
    await ClientDatabase().syncClientsToFirebase();
  }
}

class ProductDatabase {
  static final ProductDatabase _instance = ProductDatabase._internal();
  static Database? _database;

  int idGenerator() {
    String n1 = (Random().nextInt(10) + 1).toString();
    String n2 = (Random().nextInt(10) + 1).toString();
    String n3 = (Random().nextInt(10) + 1).toString();
    String n4 = (Random().nextInt(10) + 1).toString();
    String n5 = (Random().nextInt(10) + 1).toString();
    String n6 = (Random().nextInt(10) + 1).toString();
    String n7 = (Random().nextInt(10) + 1).toString();
    String n8 = (Random().nextInt(10) + 1).toString();
    String n9 = (Random().nextInt(10) + 1).toString();
    String n10 = (Random().nextInt(10) + 1).toString();

    var id = n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8 + n9 + n10;
    return int.parse(id);
  }

  factory ProductDatabase() {
    return _instance;
  }

  ProductDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  getbyid(id) async {
    var Product = await _database!.query(
      'products',
      where: 'id = ?', // Cláusula WHERE
      whereArgs: [id], // Substitui o "?" pelo valor do ID
      limit: 1, // Opcional: retorna apenas 1 linha
    );
    String databaseID = Product[0]['id'].toString();
    String requestID = id;

    if (databaseID == requestID) {
      return Product[0];
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'products.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE products(
          id INTEGER PRIMARY KEY, 
          name TEXT UNIQUE, 
          owner TEXT, 
          cost REAL, 
          price REAL, 
          image BLOB,
          synced INTEGER,
          stock INTEGER)''',
        );
      },
    );
  }

  Future<void> insertProduct(Uint8List imageData, String name, double cost,
      double price, int amount) async {
    final db = await database;
    var id = idGenerator();
    final List<Map<String, dynamic>> maps = await db.query('products');
    List CurrentIDs = List.generate(maps.length, (i) {
      return maps[i]['image'] as Uint8List;
    });
    if (CurrentIDs.contains(id) == false) {
      try {
        await db.insert('products', {
          'id': id,
          'image': imageData,
          'name': name,
          // provisório, mudar isso aqui quando for criada a estrutura de cadastro
          'owner': "Luana",
          'cost': cost,
          'price': price,
          'synced': 0,
          'stock': amount
        });
      } catch (e) {
        print(
            "Erro:Produto já cadastrado."); // Mensagem de erro para duplicatas
      }

      // verificar aqui depois, o que fazer se o ID gerado for igual a um existente
      // OBS: a chance disso acontecer é de 1 em (10b - numero atual de produtos)
    }
  }

  Future<bool> verifyId(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    List idList = await List<String>.generate(maps.length, (i) {
      String ID = maps[i]['id'] as String;
      return ID;
    });

    if (idList.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<dynamic>> getProduct() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      Uint8List image = maps[i]['image'] as Uint8List;
      String name = maps[i]['name'] as String;
      String ID = maps[i]['id'].toString();
      double price = (maps[i]['price']) as double;

      return [image, ID, name, price];
    });
  }

  // Função para excluir uma imagem do banco de dados
  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> SellProduct(int id, String field, dynamic value) async {
    final db = await database;

    try {
      await db.update(
        'products',
        {field: value},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
    }
  }
}

class Logo {
  static final Logo _instance = Logo._internal();
  static Database? _database;

  factory Logo() {
    return _instance;
  }

  Logo._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'logo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE logo(id INTEGER PRIMARY KEY AUTOINCREMENT, image BLOB)',
        );
      },
    );
  }

  Future<void> insertLogo(Uint8List imageData) async {
    final db = await database;
    await db.insert('logo', {
      'image': imageData,
    });
    await db.delete(
      'logo',
    );
    await db.insert('logo', {
      'image': imageData,
    });
  }

  Future<Uint8List> displayLogo() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('logo');
    return maps[0]['image'];
  }
}

Future<void> pickLogo() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    // Converte o arquivo para Uint8List
    File file = File(pickedFile.path);
    Uint8List imageData = await file.readAsBytes(); // Lê o arquivo como bytes

    // Salva a imagem como BLOB no banco de dados
    await Logo().insertLogo(imageData);
  } else {
    // ajustar depois
    print('Nenhuma imagem selecionada.');
  }
}

class User_Database {
  FirebaseAuth auth = FirebaseAuth.instance;
  dynamic user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Database? _database;
  static Database? _userdata;
  static Database? _role;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await userDatabase();
    return _database!;
  }

  Future<Database> get userdata async {
    if (_userdata != null) return _userdata!;
    _userdata = await userInfo();
    return _userdata!;
  }

  Future<Database> get role async {
    if (_role != null) return _role!;
    _role = await Role();
    return _role!;
  }

  userDatabase() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE user_data(
          data TEXT,
          receita REAL,
          lucro REAL,
          comissão REAL,
          id TEXT,
          productID TEXT,
          quantidade INTEGER,
          synced INTEGER)''',
        );
      },
    );
  }

  userInfo() async {
    String path = join(await getDatabasesPath(), 'perfil.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE perfil(
          nome TEXT,
          cpf TEXT,
          email TEXT,
          telefone TEXT,
          cargo TEXT,
          comissão REAL,
          dataCadastro TEXT)''',
        );
      },
    );
  }

  Role() async {
    String path = join(await getDatabasesPath(), 'role.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE role(
          Cargo TEXT,
          Produtos INTEGER,
          Clientes INTEGER,
          Revendedoras INTEGER,
          Financeiro INTEGER,
          Sistema INTEGER)''',
        );
      },
    );
  }

  _getuserdataFirebase() async {
    String id = await user!.uid;
    var db = await userdata;
    await db.delete('perfil');
    var info = _firestore.collection("/Cadastros/Luana/Revendedoras");
    var doc = await info.doc(id).get();
    String name = doc.data()!['nome'];
    String cpf = doc.data()!['cpf'];
    String email = doc.data()!['email'];
    String phone = doc.data()!['telefone'];
    double comission = doc.data()!['comissão'];
    String role = doc.data()!['cargo'];
    DateTime date = doc.data()!['dataCadastro'].toDate();
    String formattedDate =
        "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}:${date.second}";
    await db.insert('perfil', {
      "nome": name,
      "cpf": cpf,
      "email": email,
      "telefone": phone,
      "comissão": comission,
      "cargo": role,
      "dataCadastro": formattedDate,
    });
  }

  getUserRole() async {
    var db = await userdata;
    try {
      List<Map<String, dynamic>> result = await db.query(
        'perfil',
        columns: ['cargo'],
        limit: 1,
      );
      return await result.first['cargo'];
    } catch (e) {
      await _getuserdataFirebase();
      List<Map<String, dynamic>> result = await db.query(
        'perfil',
        columns: ['cargo'],
        limit: 1,
      );
      return await result.first['cargo'];
    }
  }

  //funçaõ para criar os cargos, a ideia é uma lista com o nome de um elemento do sistema como chave, e o valor dessa chave sendo um int de 0 a 2
  // 0: sem premissão nenhuma
  // 1: permissão de ler
  // 2: permissão de ler e escrever(editar/adicionar)
  MakeRole(
      {required String? nome,
      required int? produtos,
      required int? clientes,
      required int? sistema,
      required int? revendedoras,
      required int? financeiro}) {
    var pasta = _firestore.collection("/Cadastros/Luana/Cargos");
    pasta.doc(nome).set({
      'Cargo': nome,
      'Produtos': produtos,
      'Clientes': clientes,
      'Sistema': sistema,
      'Revendedoras': revendedoras,
      'Financeiro': financeiro
    });
  }

  GetPermissions({
    required String? cargo,
  }) async {
    var db = await role;
    try {
      List<Map<String, dynamic>> result = await db
          .query('role', limit: 1, where: 'Cargo = ?', whereArgs: [cargo]);
      return await result.first;
    } catch (e) {
      await _getRolesFirebase();
      List<Map<String, dynamic>> result = await db
          .query('role', limit: 1, where: 'Cargo = ?', whereArgs: [cargo]);
      return await result.first;
    }
  }

  _getRolesFirebase() async {
    String cargo = UserDataCache.Cargo!;
    var cargo_info =
        await _firestore.collection("/Cadastros/Luana/Cargos").doc(cargo).get();
    var db = await role;
    var cargoData = cargo_info.data()!;
    await db.insert('role', {
      'Cargo': cargoData['Cargo'],
      'Produtos': cargoData['Produtos'],
      'Clientes': cargoData['Clientes'],
      'Sistema': cargoData['Sistema'],
      'Revendedoras': cargoData['Revendedoras'],
      'Financeiro': cargoData['Financeiro']
    });
  }

  getProduct(id) async {
    dynamic db = await ProductDatabase().database;
    var result = await db.query('products', where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<double?> getComission() async {
    var db = await userdata;
    try {
      List<Map<String, dynamic>> result = await db.query(
        'perfil',
        columns: ['comissão'],
        limit: 1,
      );
      return await result.first['comissão'] as double;
    } catch (e) {
      await _getuserdataFirebase();
      List<Map<String, dynamic>> result = await db.query(
        'perfil',
        columns: ['comissão'],
        limit: 1,
      );
      return await result.first['comissão'] as double;
    }
  }

  insertSell(
      {required double? comissao,
      required double? receita,
      required double? lucro,
      required String? productID}) async {
    DateTime tempo = DateTime.now();
    String data = DateFormat("yyyy/MM/dd HH:mm").format(tempo);
    String formated = DateFormat("yyyyMMddHHmmssSSS").format(tempo);
    String id = formated.split('').reversed.join('');
    var db = await database;
    await db.insert('user_data', {
      'data': data,
      'comissão': comissao,
      'receita': receita,
      'lucro': lucro,
      'id': id,
      'productID': productID,
      'quantidade': 1,
      'synced': 0,
    });
    SyncSellstoFirebase();
  }

  SyncSellstoFirebase() async {
    var db = await database;
    String uid = await user!.uid;

    var result =
        await db.query('user_data', where: 'synced = ?', whereArgs: [0]);
    result.forEach((row) async {
      dynamic data = row['data'];
      dynamic id = row['id'];
      dynamic lucro = row['lucro'];
      dynamic productID = row['productID'];
      dynamic comissao = row['comissão'];
      dynamic receita = row['receita'];
      var cloud =
          _firestore.collection("/Cadastros/Luana/Revendedoras/$uid/Vendas");
      cloud.doc(id).set({
        'id': id,
        'data': data,
        'receita': receita,
        'lucro': lucro,
        'comissão': comissao,
        'productID': productID,
      });
      await db.update('user_data', {'synced': 1},
          where: 'id = ?', whereArgs: [id]);
    });
  }

  getSells() async {
    var db = await database;
    var result = await db.query('user_data');
    Map agrupamento = {};
    List agrupado = [];

    for (var venda in result) {
      var id = venda['productID'];
      if (agrupamento.containsKey(id)) {
        var update_quantidade =
            agrupamento[id]!['quantidade'] + venda['quantidade'];
        var update_lucro = agrupamento[id]!['lucro'] + venda['lucro'];
        var update_comissao = agrupamento[id]!['comissão'] + venda['comissão'];
        var update_receita = agrupamento[id]!['receita'] + venda['receita'];
        agrupamento[id]['quantidade'] = update_quantidade;
        agrupamento[id]['lucro'] = update_lucro;
        agrupamento[id]['comissão'] = update_comissao;
        agrupamento[id]['receita'] = update_receita;
      } else {
        Map<String, dynamic> Convert = Map<String, dynamic>.from(venda);
        agrupamento.putIfAbsent(id, () => Convert);
      }
    }
    agrupado = agrupamento.values.toList();
    return agrupado;
  }

  Future<int> getTotalQuantidade(String productID) async {
    final db = await database; // Obtém a instância do banco de dados
    final result = await db.rawQuery(
        'SELECT SUM(quantidade) as total FROM user_data WHERE productID = ?',
        [productID]);

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    } else {
      return 0; // Retorna 0 se não houver valores na coluna
    }
  }

  Add_user({
    required String? email,
    required String? password,
    required String? name,
    required String? number,
    required String? cpf,
    required double? comission,
    required String? role,
  }) async {
    String _tratarErroFirebase(String code) {
      switch (code) {
        case 'invalid-email':
          return "O e-mail fornecido é inválido.";
        case 'user-not-found':
          return "Usuário não encontrado.";
        case 'wrong-password':
          return "Senha incorreta.";
        case 'email-already-in-use':
          return "Este e-mail já está em uso.";
        case 'weak-password':
          return "A senha é muito fraca.";
        case 'network-request-failed':
          return "Falha de conexão com a internet.";
        default:
          return "Erro desconhecido: $code";
      }
    }

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email!.trim(), password: password!.trim());
      String id = userCredential.user!.uid;
      var make_seller =
          await _firestore.collection("/Cadastros/Luana/Revendedoras");

      make_seller.doc(id).set({
        "nome": name!.trim(),
        "cpf": cpf!.trim(),
        "email": email!.trim(),
        "telefone": number!.trim(),
        "comissão": comission!,
        "cargo": role,
        "dataCadastro": FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (error) {
      return _tratarErroFirebase(error.code);
    }
  }

  Future<void> carregarDadosDoUsuario() async {
    String cargo = await getUserRole();
    // Armazena o cargo
    UserDataCache.Cargo = cargo;
    // Armazena o as permissões
    UserDataCache.Permissoes = await GetPermissions(cargo: cargo);
    print(UserDataCache.Permissoes);
  }
}

class UserDataCache {
  static String? Cargo;
  static Map? Permissoes;
}
