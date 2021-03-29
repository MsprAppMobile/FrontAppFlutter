import 'package:coupon/detailPromo.dart';
import 'package:coupon/main.dart';
import 'package:coupon/scan.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Promo {
  final int id;
  final String name;
  final String expirationDate;
  final String image;
  final String description;
  final String identifiantQr;
  //final bool isUnique;

  Promo({
    this.id,
    this.name,
    this.expirationDate,
    this.image,
    this.description,
    this.identifiantQr,
    //this.isUnique,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      id: json['id'] as int,
      name: json['name'] as String,
      expirationDate: json['expiration_date'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      identifiantQr: json['identifiant_QRCode'] as String,
      //isUnique: json['is_unique'] as bool,
    );
  }
}

Future<List<Promo>> fetchPromos(http.Client client) async {
  final response = await client.get(
      'http://10.0.2.2:5000/list/' + globals.user_id.toString(),
      //final response = await client.get('http://172.16.18.16:5000/codes',
      headers: {"Content-Type": "application/json", "token": globals.token});

  // Use the compute function to run parseBieres in a separate isolate.
  //print('Response body: ${response.body}');
  print(response.statusCode);
  return compute(parseBieres, response.body);
}

List<Promo> parseBieres(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Promo>((json) => Promo.fromJson(json)).toList();
}

class PromosList extends StatelessWidget {
  final List<Promo> promos;

  PromosList({Key key, this.promos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: promos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(promos[index].name),
          subtitle: Text(promos[index].expirationDate.toString()),
          trailing: const Icon(Icons.keyboard_arrow_right),
          dense: false,
          onTap: () async {
            globals.promoIndex = promos[index].id;
            globals.namePromo = promos[index].name;
            globals.description = promos[index].description;

            globals.idQr = promos[index].identifiantQr;
            globals.expiration_date = promos[index].expirationDate;
            print(promos[index].expirationDate.toString());

            runApp(Detail());
          },
        );
      },
    );
  }
}

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
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
      home: MyHomePage(title: 'Vos promotions !'),
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final items = List<String>.generate(30, (i) => "Promotion n° $i");

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
            icon: Icon(Icons.logout),
            onPressed: () {
              runApp(Auth());
            }),
      ),
      body: FutureBuilder<List<Promo>>(
        future: fetchPromos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PromosList(promos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ScanQR()));
        },
        tooltip: 'qrcode',
        child: Icon(Icons.qr_code_scanner_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
