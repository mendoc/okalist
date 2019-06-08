class Liste {
  final int id;
  final String intitule;
  final int timestamp;

  Liste({this.id, this.intitule, this.timestamp});

  Map<String, dynamic> toMap() =>
      {"id": id, "intitule": intitule, "timestamp": timestamp};

  @override
  String toString() => "Liste {$id, $intitule, $timestamp}";
}
