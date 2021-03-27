import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';

class AjoutAdmin extends StatefulWidget {
  @override
  _AjoutAdmin createState() => _AjoutAdmin();
}

class _AjoutAdmin extends State<AjoutAdmin> {
  final nameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gérer les utilisateurs"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pseudo (user)',
              ),
              controller: nameCtrl,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password (user)',
              ),
              controller: passwordCtrl,
            ),
            SizedBox(
              height: 15.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15),
              onPressed: () async {},
              child: Text(
                "Changer le rôle",
                style: TextStyle(color: Colors.indigo[900]),
              ),
              //Button having rounded rectangle border
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.indigo[900]),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
