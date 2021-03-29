import 'dart:convert';
import 'package:coupon/home.dart';
import 'package:coupon/adminHome.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:dropdownfield/dropdownfield.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(Auth());
}

class Auth extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Pinte',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Authentification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String contry_id;
  List<String> contry = ["Monsieur", "Madame", "Non défini"];
  final pseudoCtrlr = TextEditingController();
  final passwordCtrlr = TextEditingController();
  final passwordCtrlr2 = TextEditingController();
  final nomCtrlr = TextEditingController();
  final genreCtrlr = TextEditingController();
  final compAdrCtrlr = TextEditingController();
  final prenomCtrlr = TextEditingController();
  final mailCtrlr = TextEditingController();
  final telCtrlr = TextEditingController();
  final codePCtrlr = TextEditingController();
  final villeCtrlr = TextEditingController();
  final adresseCtrlr = TextEditingController();

  String decodeBase64(String str) {
    //'-', '+' 62nd char of encoding,  '_', '/' 63rd char of encoding
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      // Pad with trailing '='
      case 0: // No pad chars in this case
        break;
      case 2: // Two pad chars
        output += '==';
        break;
      case 3: // One pad char
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Future<String> _authentification() async {
    Map data = {'pseudo': pseudoCtrlr.text, 'password': passwordCtrlr.text};
    globals.userName = pseudoCtrlr.text;
    globals.isExist = 'non';
    String body = json.encode(data);
    var url = 'http://10.0.2.2:5001/login';
    //var url = 'http://172.16.18.16:5001/login';
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    //var test = json.decodeBase64(response.body);
    globals.statuscode = response.statusCode;

    if (response.statusCode == 200) {
      final parts = response.body.split('.');
      if (parts.length != 3) {
        throw Exception('invalid token');
      }

      final payload = decodeBase64(parts[1]);
      final payloadMap = json.decode(payload);
      print(payloadMap['role'].toString());
      globals.user_id = payloadMap['user_id'];
      globals.role = payloadMap['role'];
      globals.token = response.body;
    }
  }

  Future<String> _isExist(String pseudo, String password) async {
    Map data = {'pseudo': pseudo, 'password': password};
    String body = json.encode(data);
    var url = 'http://10.0.2.2:5001/login';
    //var url = 'http://172.16.18.16:5001/login';
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    //var test = json.decodeBase64(response.body);
    globals.statuscode = response.statusCode;

    if (response.statusCode == 200) {
      globals.isExist = 'Exist';
    }
    return "";
  }

  Future<String> _createUser() async {
    globals.formAdd = '';
    globals.isExist = '';
    if (nomCtrlr.text.isEmpty ||
        mailCtrlr.text.isEmpty ||
        passwordCtrlr2.text.isEmpty ||
        telCtrlr.text.isEmpty ||
        genreCtrlr.text.isEmpty ||
        codePCtrlr.text.isEmpty ||
        codePCtrlr.text.length != 5 ||
        villeCtrlr.text.isEmpty ||
        adresseCtrlr.text.isEmpty) {
      globals.formAdd = '';
      return "Fin";
    }

    /*if (codePCtrlr.text.length != 5) {
      return "";
    }*/
    /* _isExist(nomCtrlr.text, passwordCtrlr2.text);
     if (globals.isExist != 'Exist') {
      globals.formAdd = 'exist';
      return 'Fin';
    }*/
    Map data = {
      'pseudo': nomCtrlr.text,
      'mail': mailCtrlr.text,
      'password': passwordCtrlr2.text,
      'telephone': telCtrlr.text,
      'genre': genreCtrlr.text,
      'codeP': codePCtrlr.text,
      'ville': villeCtrlr.text,
      'adresse': adresseCtrlr.text,
      'complementAdresse': compAdrCtrlr.text,
      'role': 'user'
    };

    var url = 'http://10.0.2.2:5001/users';
    //var url = 'http://172.16.18.16:5001/login';
    String body = json.encode(data);

    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    //var test = json.decodeBase64(response.body);

    if (response.statusCode == 200) {
      globals.formAdd = 'ok';
    }
  }

  @override
  Widget build(BuildContext context) {
    String formGenre = 'Genre';
    String dropdownValue = 'First';
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
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Text(' Sign in : ', style: TextStyle(fontSize: 22))),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Login',
              ),
              controller: pseudoCtrlr,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              controller: passwordCtrlr,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
            ),
            FlatButton(
              color: Colors.blueGrey,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(9.0),
              splashColor: Colors.blueAccent,
              onPressed: () async {
                //runApp(AdminHome());
                await _authentification();
                if (globals.statuscode == 200) {
                  if (globals.role == "admin") {
                    runApp(AdminHome());
                  } else {
                    runApp(Home());
                  }
                } else {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Wrong password or login !"),
                      );
                    },
                  );
                }
              },
              child: Text(
                "Connexion",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            FlatButton(
              color: Colors.blueGrey,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(9.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text('Création de compte'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                DropDownField(
                                  onValueChanged: (dynamic value) {
                                    contry_id = value;
                                  },
                                  value: contry_id,
                                  //required: true,
                                  labelText: 'Genre',
                                  items: contry,
                                  controller: genreCtrlr,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Pseudo',
                                    icon: Icon(Icons.contact_page),
                                  ),
                                  controller: nomCtrlr,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    icon: Icon(Icons.contact_page),
                                  ),
                                  controller: passwordCtrlr2,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    icon: Icon(Icons.email),
                                  ),
                                  controller: mailCtrlr,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Code Postal',
                                    icon: Icon(Icons.add_location_alt_sharp),
                                  ),
                                  controller: codePCtrlr,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Ville',
                                    icon: Icon(Icons.add_location_alt_sharp),
                                  ),
                                  controller: villeCtrlr,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Adresse',
                                    icon: Icon(Icons.add_location_alt_sharp),
                                  ),
                                  controller: adresseCtrlr,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Complément Adresse (optionel)',
                                    icon: Icon(Icons.add_location_alt_sharp),
                                  ),
                                  controller: compAdrCtrlr,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Téléphone',
                                    icon: Icon(Icons.add_call),
                                  ),
                                  controller: telCtrlr,
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          RaisedButton(
                              child: Text("Submit"),
                              onPressed: () async {
                                await _createUser();
                                if (globals.formAdd == 'ok') {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Votre compte à bien été créer !"),
                                      );
                                    },
                                  );
                                } else if (globals.formAdd == 'exist') {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Erreur: Ce pseudo est déjà pris par un autre utilisateur"),
                                      );
                                    },
                                  );
                                } else {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Erreur: vérifié que les informations saisi sont valident."),
                                      );
                                    },
                                  );
                                }
                                // your code
                              })
                        ],
                      );
                    });
              },
              child: Text(
                "Pas encore de compte",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Text(
              "@Version 1.3.1",
              style: TextStyle(fontSize: 8.0),
            ),
          ],
        ),
      ),
    );
  }
}
