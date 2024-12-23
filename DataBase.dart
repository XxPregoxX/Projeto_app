import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ClientDatabase {
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

class SyncService {
  Future<void> syncDataToFirebase() async {
    await Firebase.initializeApp();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final ClientDatabase _localDb = ClientDatabase();
    // Pegar os dados locais que não foram sincronizados (synced = 0)
    List<Map<String, dynamic>> unsyncedClients = await _localDb.getClients();

    // Para cada cliente não sincronizado, vamos enviá-lo ao Firestore
    for (var client in unsyncedClients) {
      if (client['synced'] == 0) {
        // campo temporario mudar "Luana para variavel de ususario ADM"
        await _firestore
            .collection(
                '/Cadastros/Luana/Revendedoras/Leonardo Borges/Clientes')
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
    await SyncService().syncDataToFirebase();
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
      String ID = maps[i]['id'].toString() as String;
      return ID;
    });

    if (idList.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<dynamic>> getImages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      Uint8List image = maps[i]['image'] as Uint8List;
      String name = maps[i]['name'] as String;
      String ID = maps[i]['id'].toString() as String;
      double price = (maps[i]['price']) as double;

      return [image, ID, name, price];
    });
  }

  // Função para excluir uma imagem do banco de dados
  Future<void> deleteImage(int id) async {
    final db = await database;
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
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
