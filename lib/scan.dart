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

  Future<String> _analyseRequete(String code) async {
    if (code.isNotEmpty) {
      int fin = code.indexOf(';');
      promoCode = code.substring(0, fin);

      if (promoCode /*.DecodeMd5() un truc du genre*/ == 'gostyle') {
        String idPromo = _isExist(code.substring(fin)) as String;
      }

      //1er gostyle crypter test jusqu'a ; (encode md5)
      //si bon 2eme partie identifiant qr ; test si identifiantexist
    }
  }

  Future<String> _isExist(identifiant) async {
    // Récupération de la localisation actuelle de l'utilisateur
    // Construction de l'URL a appeler
    //var url = 'http://10.0.2.2:5000/favorite/' + globals.user_id.toString();
    var url = 'http://10.0.0.2:5000/code/' + identifiant;
    // Appel
    var response = await http.get(url,
        headers: {"Content-Type": "application/json", "token": globals.token});
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    globals.isfav = response.body.contains(globals.namePromo);

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
              onPressed: () async {
                String codeSanner = await BarcodeScanner.scan();
                await _analyseRequete(codeSanner); //barcode scnner
                setState(() {
                  qrCodeResult = codeSanner;
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
