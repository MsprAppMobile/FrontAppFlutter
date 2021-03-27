import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String qrCodeResult = "Vous n'avez encore rien scanner";
  String promoCode = '';

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  // ignore: missing_return
  Future<String> _analyseRequete(String code) async {
    if (code.isNotEmpty) {
      int fin = code.indexOf(';');
      promoCode = code.substring(0, fin);

      if (promoCode == generateMd5('GoStyle')) {
        _isExist(code.substring(fin + 1));
        //idPromo = 'ok';
        if (globals.isExist == 'ok') {
          _addCodeList();
        }
        //si code existant alors ajout a la table codelist
      }

      //1er gostyle crypter test jusqu'a ; (encode md5)
      //si bon 2eme partie identifiant qr ; test si identifiantexist
    }
  }

  Future<String> _isExist(identifiant) async {
    // Récupération de la localisation actuelle de l'utilisateur
    // Construction de l'URL a appeler
    //var url = 'http://10.0.2.2:5000/favorite/' + globals.user_id.toString();
    var url = 'http://10.0.2.2:5000/code2/' + identifiant;
    print(identifiant);
    // Appel
    var response = await http.get(url,
        headers: {"Content-Type": "application/json", "token": globals.token});
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    //globals.isfav = response.body.contains(globals.namePromo);
    if (response.statusCode == 200) {
      print('is exist ok');
      globals.isExist = 'ok';
    }
    return response.body;
  }

  Map data = {'code_id': 1, 'user_id': globals.user_id, 'status': 1};

  Future<String> _addCodeList() async {
    String bodyData = json.encode(data);
    print('fin');
    // Récupération de la localisation actuelle de l'utilisateur
    // Construction de l'URL a appeler
    //var url = 'http://10.0.2.2:5000/favorite/' + globals.user_id.toString();
    var url = 'http://10.0.2.2:5000/list';
    // Appel
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "token": globals.token},
      body: bodyData,
    );
    /*code_id, user_id, status*/
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    //globals.isfav = response.body.contains(globals.namePromo);
    print(response.statusCode.toString());
    print('fin2');
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner un QR Code"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Message displayed over here
            Text(
              "",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),

            //Button to scan QR code
            FlatButton(
              padding: EdgeInsets.all(15),
              onPressed: () {
                //String codeSanner = await BarcodeScanner.scan();
                _analyseRequete(generateMd5('GoStyle') +
                    ';identifiantcode'); //barcode scnner
                setState(() {
                  qrCodeResult = 'test' /*codeSanner*/;
                });
              },
              child: Text(
                "Scanner",
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
