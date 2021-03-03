import 'package:coupon/home.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:qr_flutter/qr_flutter.dart';

void main() => runApp(Scan());

class Scan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRCode Scan',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String scanResult = '';
//function that launches the scanner
  Future scanQRCode() async {
    String cameraScanResult = await scanner.scan();
    setState(() {
      scanResult = cameraScanResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scan '),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {
              runApp(Home());
            }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            scanResult == ''
                ? Text('Result will be displayed here')
                : Text(scanResult),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.red,
              child: Text(
                'Click To Scan',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: scanQRCode,
            )
          ],
        ),
      ),
    );
  }
}
