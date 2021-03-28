import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AjoutAdmin extends StatefulWidget {
  @override
  _AjoutAdmin createState() => _AjoutAdmin();
}

class _AjoutAdmin extends State<AjoutAdmin> {
  final nameCtrl = TextEditingController();
  final mailCtrl = TextEditingController();

  Future<String> _changeRole() async {
    globals.ajoutadmin = '';
    globals.rolemod = '';
    Map data = {'role': 'admin'};

    await _getRole(nameCtrl.text);

    if (globals.rolemod == 'admin') {
      globals.ajoutadmin = 'User ' + nameCtrl.text + ' est passé user';
      data = {'role': 'user'};
    } else {
      globals.ajoutadmin = 'User ' + nameCtrl.text + ' est passé admin';
      data = {'role': 'admin'};
    }

    String bodyData = json.encode(data);
    var url = 'http://10.0.2.2:5001/user/' + globals.user_idmod.toString();
    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json", "token": globals.token},
      body: bodyData,
    );
    //print(response.statusCode.toString());
  }

  Future<String> _getRole(String pseudo) async {
    globals.ajoutadmin = '';
    var url = 'http://10.0.2.2:5001/user/' + pseudo;
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json", "token": globals.token},
    );
    //print('Response body: ${response.body}');
    final Map parsed = json.decode(response.body);
    print(parsed['id']);
    print(parsed['role']);
    globals.user_idmod = parsed['id'].toString();
    globals.rolemod = parsed['role'].toString();

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gérer les utilisateurs"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pseudo (user)',
              ),
              controller: nameCtrl,
            ),
            /*  Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mail (user)',
              ),
              controller: mailCtrl,
            ),*/
            SizedBox(
              height: 15.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15),
              onPressed: () async {
                await _changeRole();
                // await _getRole(nameCtrl.text);

                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(globals.ajoutadmin),
                    );
                  },
                );
              },
              child: Text(
                "Changer son rôle",
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
