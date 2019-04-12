import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/ClientModel.dart';
import 'package:flutter_app/SecondModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "address TEXT,"
          "mobile TEXT"
          ")");
      await db.execute("CREATE TABLE Mat ("
          "id INTEGER PRIMARY KEY,"
          "userdetails TEXT,"
          "quantity TEXT,"
          "price TEXT,"
          "totalprice TEXT"
          ")");
    });
  }

  newClient(Client newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Client (id,name,address,mobile)"
        " VALUES (?,?,?,?)",
        [id, newClient.Name, newClient.Address, newClient.Mobile]);
    return raw;
  }

  newSecond(Second newSecond) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Mat");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Mat (id,userdetails,quantity,price,totalprice)"
        " VALUES (?,?,?,?,?)",
        [
          id,
          newSecond.Userdetails,
          newSecond.Quantity,
          newSecond.Price,
          newSecond.Totalprice
        ]);
    return raw;
  }

//  blockOrUnblock(Client client) async {
//    final db = await database;
//    Client blocked = Client(
//        id: client.id,
//        firstName: client.firstName,
//        lastName: client.lastName,
//        blocked: !client.blocked);
//    var res = await db.update("Client", blocked.toMap(),
//        where: "id = ?", whereArgs: [client.id]);
//    return res;
//  }

  updateClient(Client newClient) async {
    final db = await database;
    var res = await db.update("Client", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.query("Client");
    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Client");
  }

  updateSecond(Second newSecond) async {
    final db = await database;
    var res = await db.update("Mat", newSecond.toMap(),
        where: "id = ?", whereArgs: [newSecond.id]);
    return res;
  }

  getSecond(int id) async {
    final db = await database;
    var res = await db.query("Mat", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Second.fromMap(res.first) : null;
  }

  Future<List<Second>> getAllSecond() async {
    final db = await database;
    var res = await db.query("Mat");
    List<Second> list =
        res.isNotEmpty ? res.map((c) => Second.fromMap(c)).toList() : [];
    return list;
  }

  deleteSecond(int id) async {
    final db = await database;
    return db.delete("Mat", where: "id = ?", whereArgs: [id]);
  }

  deleteSecondAll() async {
    final db = await database;
    db.rawDelete("Delete * from Mat");
  }
}
