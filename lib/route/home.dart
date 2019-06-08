import 'package:flutter/material.dart';
import 'package:okalist/model/liste.dart';
import 'package:okalist/utils/master.dart';
import 'package:okalist/utils/okalist_db.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Liste>> listesFuture;
  OkalistDB okalistDB = OkalistDB();
  int nb_listes = 0;
  final controller = TextEditingController();

  void addListe() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Intitulé de la liste"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: controller,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Annuler",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  controller.text = "";
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Enregistrer"),
                onPressed: () {
                  String intitule = controller.text;
                  if (intitule.length > 0) {
                    okalistDB
                        .createListe(
                      Liste(
                        intitule: intitule,
                        timestamp: DateTime.now().millisecondsSinceEpoch,
                      ),
                    )
                        .whenComplete(
                      () {
                        updateListe();
                        controller.text = "";
                        Navigator.of(context).pop();
                      },
                    );
                  }
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Text(
              "$nb_listes",
              style: TextStyle(
                fontFamily: "Worksans",
                fontSize: 18.0,
              ),
            ),
          ))
        ],
        title: Text(
          "TOUTES LES LISTES",
          style: TextStyle(
            fontFamily: "Worksans",
          ),
        ),
      ),
      body: FutureBuilder<List<Liste>>(
        future: listesFuture,
        builder: (context, snap) {
          if (snap.data == null) {
            return Center(
              child: Text(
                "Aucune liste trouvée",
                style: TextStyle(fontFamily: "WorkSans"),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (context, position) {
                Liste liste = snap.data.elementAt(position);
                String date = formatDate(liste.timestamp);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                liste.intitule,
                                style: TextStyle(
                                  fontFamily: "Worksans",
                                  fontSize: 18.0,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 3.0),
                                      child: Icon(
                                        Icons.watch_later,
                                        color: Colors.grey,
                                        size: 12.0,
                                      ),
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        fontFamily: "Worksans",
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    (liste == snap.data.last) ? Container(height: 80.0,) : Container()
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            addListe();
          },
          label: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.add),
              ),
              Text("Ajouter"),
            ],
          )),
    );
  }

  @override
  void initState() {
    updateListe();
  }

  void updateListe() {
    listesFuture = okalistDB.allListe();
    listesFuture.then((toutesLesListes) {
      nb_listes = toutesLesListes.length;
      setState(() {});
    });
  }
}