class Nom {
  final int id;
  final String nomcomplet;
  final int liste;
  final int timestamp;

  Nom({this.id, this.nomcomplet, this.liste, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nom": nomcomplet,
      "liste": liste,
      "timestamp": timestamp
    };
  }

  @override
  String toString() => "Nom{$id, $nomcomplet, $liste, $timestamp}";

}