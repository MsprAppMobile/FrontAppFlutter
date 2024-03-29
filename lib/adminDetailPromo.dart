import 'package:coupon/adminHome.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

void main() {
  runApp(AdminDetail());
}

Future<String> _supPromos() async {
  // var url = 'http://10.0.2.2:5000/code/' + globals.promoid.toString();
  var url = 'http://172.16.18.27:5000/code/' + globals.promoid.toString();

  http.Response response = await http.delete(
    url,
    headers: {"Content-Type": "application/json", "token": globals.token},
  );
  return response.body;
}

String _promounique() {
  if (globals.isunique == 1) {
    return 'Non';
  } else
    return 'Oui';
}

class AdminDetail extends StatelessWidget {
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
      home: MyHomePage(title: 'Détail de la promotion'),
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
        title: Text(globals.namePromo),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {
              runApp(AdminHome());
            }),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(children: <Widget>[
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Date d\'expiration: ' +
                    globals.expiration_date.toString().substring(0, 16)),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Description : ' + globals.description),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Id promo : ' + globals.idQr),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Promo renouvelable: ' + _promounique()),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
          ),
          FlatButton(
            padding: EdgeInsets.all(15),
            onPressed: () async {
              await _supPromos();
              runApp(AdminHome());
            },
            child: Text(
              "Supprimer la promotion",
              style: TextStyle(color: Colors.indigo[900]),
            ),
            //Button having rounded rectangle border
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.indigo[900]),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ]),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
