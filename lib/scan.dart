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
      print('1-pormoCode : ' + promoCode);
      print("2- promo = gostyle md5" + generateMd5('GoStyle'));

      if (promoCode == generateMd5('GoStyle')) {
        print('3-Avant isExist');
        await _isExist(code.substring(fin + 1));
        //idPromo = 'ok';
        if (globals.isExist == 'ok') {
          _addCodeList();
        }
      }
    }
    return 'fin';
  }

  Future<String> _isExist(identifiant) async {
    print('4-dans isexist');

    //  var url = 'http://10.0.2.2:5000/code/' + identifiant;
    var url = 'http://172.16.18.27:5000/code/' + identifiant.toString();

    print(identifiant);
    var response = await http.get(url,
        headers: {"Content-Type": "application/json", "token": globals.token});

    if (response.statusCode == 200) {
      print('5-response' + response.statusCode.toString());
      globals.isExist = 'ok';
    }
    return response.body;
  }

  Future<String> _addCodeList() async {
    Map data = {'code_id': 1, 'user_id': globals.user_id, 'status': 1};

    String bodyData = json.encode(data);
    print('6-addCode dedans');

    //  var url = 'http://10.0.2.2:5000/list';
    var url = 'http://172.16.18.27:5000/list';
// Appel
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "token": globals.token},
      body: bodyData,
    );

    print('7-ajout code status' + response.statusCode.toString());

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
                //String codeSanner = await BarcodeScanner.scan();
                await _analyseRequete(
                    '0ae1a9e5054cb4e016645a97b6f9a3f5;1254'); //barcode scnner
                setState(() {
                  qrCodeResult = 'test'; //codeSanner;
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
