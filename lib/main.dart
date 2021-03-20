import 'dart:convert';
import 'package:coupon/home.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
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
  final _formKey = GlobalKey<FormState>();
  final pseudoCtrlr = TextEditingController();
  final passwordCtrlr = TextEditingController();

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
    globals.isfav = true;
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

      globals.user_id = payloadMap['user_id'];
      globals.token = response.body;
    }
  }

  Future<String> sunriseSunsetTimes;

  @override
  Widget build(BuildContext context) {
    String formGenre = 'Genre';
    var _value = 1;

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
                await _authentification();
                if (globals.statuscode == 200) {
                  runApp(Home());
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
                                DropdownButton(
                                    value: _value,
                                    items: [
                                      DropdownMenuItem(
                                        child: Text("Monsieur"),
                                        value: 1,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("Madame"),
                                        value: 2,
                                      ),
                                      DropdownMenuItem(
                                          child: Text("Non binaire"), value: 3),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value;
                                      });
                                    }),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Nom',
                                    icon: Icon(Icons.contact_page),
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Prénom',
                                    icon: Icon(Icons.contact_page),
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    icon: Icon(Icons.email),
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Ville, Code Postal',
                                    icon: Icon(Icons.add_location_alt_sharp),
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Adresse',
                                    icon: Icon(Icons.add_location_alt_sharp),
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Téléphone',
                                    icon: Icon(Icons.add_call),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          RaisedButton(
                              child: Text("Submit"),
                              onPressed: () {
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
