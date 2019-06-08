import 'package:flutter/material.dart';
import 'package:okalist/model/liste.dart';

class ScanScreen extends StatefulWidget {
  final Liste liste;

  ScanScreen({Key key, @required this.liste}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState(liste);
}

class _ScanScreenState extends State<ScanScreen> {
  Liste liste;

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
      body: Center(
        child: Text(
          liste.intitule,
          style: TextStyle(fontFamily: "WorkSans"),
        ),
      ),
    );
  }
}
