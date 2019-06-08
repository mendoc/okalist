class Constant {
  static String CREATE_DB = """
  CREATE TABLE liste(
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    intitule TEXT, 
    timestamp INTEGER
  ); 
  CREATE TABLE nom(
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    nom TEXT, 
    liste INTEGER, 
    timestamp INTEGER
  );""";
  static var moisLettres = <String>[
    "janvier",
    "février",
    "mars",
    "avril",
    "mai",
    "juin",
    "juillet",
    "août",
    "septembre",
    "octobre",
    "novembre",
    "décembre",
  ];
}
