import 'package:okalist/model/liste.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'constant.dart';

class OkalistDB {
  Future<Database> database;

  OkalistDB() {
    _getDB();
  }

  Future<Database> _getDB() async {
    return openDatabase(
        join(
          await getDatabasesPath(),
          "okalist_databse.db",
        ),
        version: 1, onCreate: (db, version) {
      print("Création de la base de données");
      return db.execute(Constant.CREATE_DB);
    });
  }

  Future<void> createListe(Liste liste) async {
    final Database db = await _getDB();

    await db.insert(
      "liste",
      liste.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("Une liste a été enregistrée : $liste");
  }

  Future<void> deleteListe(Liste liste) async {
    final Database db = await _getDB();

    if (liste.id == null) return;

    await db.delete("liste", where: "id = ?", whereArgs: [liste.id]);

    print("Une liste a été supprimée : $liste");
  }

  Future<List<Liste>> allListe() async {
    final Database db = await _getDB();

    List<Map<String, dynamic>> listesMap =
        await db.query("liste", orderBy: "id desc");

    return List.generate(listesMap.length, (index) {
      return Liste(
        id: listesMap[index]["id"],
        intitule: listesMap[index]["intitule"],
        timestamp: listesMap[index]["timestamp"],
      );
    });
  }
}
