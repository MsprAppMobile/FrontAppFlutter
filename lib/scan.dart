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

  Future<String> _analyseRequete(String code) async {
    if (code.isNotEmpty) {
      int fin = code.indexOf(';');
      promoCode = code.substring(0, fin);

      if (promoCode == generateMd5('GoStyle')) {
        await _isExist(code);
        //idPromo = 'ok';
        if (globals.isExist == 'ok') {
          _addCodeList();
        }
      }
    }
    return 'fin';
  }

  Future<String> _isExist(identifiant) async {
    //  var url = 'http://10.0.2.2:5000/code/' + identifiant;
    var url = 'http://172.16.18.27:5000/codeqr/' + identifiant.toString();

    var response = await http.get(url,
        headers: {"Content-Type": "application/json", "token": globals.token});
    int virgule = response.body.indexOf(',');

    if (response.statusCode == 200) {
      globals.codeid = response.body.substring(1, virgule);
      globals.isExist = 'ok';
    }
    return response.body;
  }

  Future<String> _addCodeList() async {
    Map data = {
      'code_id': globals.codeid.toString(),
      'user_id': globals.user_id.toString(),
      'status': '0'
    };

    String bodyData = json.encode(data);

    //  var url = 'http://10.0.2.2:5000/list';
    var url = 'http://172.16.18.27:5000/list';
// Appel
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "token": globals.token},
      body: bodyData,
    );

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
                  qrCodeResult = 'Promotion ajouté !';
                });
              },
              child: Text(
                "Scanner",
                style: TextStyle(color: Colors.indigo[900]),
              ),
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
