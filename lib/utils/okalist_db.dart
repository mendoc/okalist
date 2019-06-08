import 'package:okalist/model/liste.dart';
import 'package:okalist/model/nom.dart';
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
      version: 1,
      onCreate: (db, version) {
        print("Création de la base de données");
        db.execute(Constant.CREATE_LISTE_DB);
        db.execute(Constant.CREATE_NOM_DB);
      },
    );
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

  Future<void> createNom(Nom nom) async {
    final Database db = await _getDB();

    await db.insert(
      "nom",
      nom.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("Un nom a été enregistré : $nom");
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

  Future<List<Nom>> allNoms(int liste_id) async {
    final Database db = await _getDB();

    List<Map<String, dynamic>> nomsMap =
        await db.query("nom", where: "liste = $liste_id", orderBy: "nom");

    return List.generate(nomsMap.length, (index) {
      return Nom(
        id: nomsMap[index]["id"],
        nomcomplet: nomsMap[index]["nom"],
        liste: nomsMap[index]["liste"],
        timestamp: nomsMap[index]["timestamp"],
      );
    });
  }
}
