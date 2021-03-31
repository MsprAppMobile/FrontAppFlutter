import 'package:coupon/adminAjout.dart';
import 'package:coupon/adminDetailPromo.dart';
import 'package:coupon/home.dart';
import 'package:crypto/crypto.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(Scan());
}

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
  //  var url = 'http://10.0.2.2:5000/codeqr/' + identifiant;
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
    'user_id': globals.user_id,
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

class Scan extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appli Promo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Scanner une promotion !'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<MyHomePage> {
  // final items = List<String>.generate(30, (i) => "Promotion n° $i");

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {
              runApp(Home());
            }),
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
                  if (globals.isExist == 'rien') {
                    qrCodeResult = 'Vous n\'aver encore rien scanner';
                  } else if (globals.isExist == 'ok') {
                    qrCodeResult = 'Promotion ajouté !'; //codeSanner;

                  } else {
                    qrCodeResult = 'Promotion non conforme !'; //codeSanner;

                  }
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
