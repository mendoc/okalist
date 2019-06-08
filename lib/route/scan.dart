import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:okalist/model/liste.dart';
import 'package:okalist/model/nom.dart';
import 'package:okalist/utils/master.dart';
import 'package:okalist/utils/okalist_db.dart';

class ScanScreen extends StatefulWidget {
  final Liste liste;

  ScanScreen({Key key, @required this.liste}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState(liste);
}

class _ScanScreenState extends State<ScanScreen> {
  Future<List<Nom>> noms;
  Liste liste;
  OkalistDB okalistDB = new OkalistDB();
  int nbNoms = 0;
  String message = "";

  _ScanScreenState(this.liste);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          liste.intitule,
          style: TextStyle(
            fontFamily: "WorkSans",
            fontSize: 18.0,
          ),
        ),
      ),
      body: FutureBuilder<List<Nom>>(
        future: noms,
        builder: (context, snap) {
          if (snap.data == null || snap.data.length == 0) {
            return Center(
              child: Text(
                "Cette liste est vide.",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black.withOpacity(0.5),
                    fontFamily: "WorkSans",
                    letterSpacing: 1),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (context, position) {
                  Nom nom = snap.data.elementAt(position);
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.3)))),
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              nom.nomcomplet,
                              style: TextStyle(
                                  fontFamily: "WorkSans",
                                  fontSize: 15.0,
                                  color: Colors.black.withOpacity(0.8)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "ajouté le " + formatDate(nom.timestamp),
                                style: TextStyle(
                                    fontFamily: "WorkSans",
                                    fontSize: 12.0,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: scan,
        icon: Icon(
          Icons.camera,
          size: 15.0,
        ),
        label: Text(
          "Ajouter un nom",
          style: TextStyle(fontFamily: "WorkSans", fontSize: 12.0),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    updateListe();
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      if (barcode != null) {
        okalistDB.createNom(Nom(
          nomcomplet: barcode,
          liste: this.liste.id,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));
        updateListe();
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showMessage("Pas accès à la caméra.");
      } else {
        showMessage("Erreur inconnue: $e");
      }
    } on FormatException {
    } catch (e) {
      showMessage("Oups! Quelque chose à mal tourné: $e");
    }
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Fermer"),
              )
            ],
          );
        });
  }

  void updateListe() {
    noms = okalistDB.allNoms(liste.id);
    noms.then((tousLesNoms) {
      nbNoms = tousLesNoms.length;
      setState(() {});
    });
  }
}
