import 'package:flutter/material.dart';
import 'package:okalist/route/home.dart';
import 'package:okalist/utils/okalist_db.dart';

import 'model/liste.dart';

void main() async {
  OkalistDB okalistDB = OkalistDB();

  Liste liste = Liste(
    intitule: "Volontaires Sambas Professionnels",
    timestamp: DateTime.now().millisecondsSinceEpoch,
  );

  //okalistDB.createListe(liste);

  print(await okalistDB.allListe());

  runApp(Okalist());
}

class Okalist extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Okalist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
