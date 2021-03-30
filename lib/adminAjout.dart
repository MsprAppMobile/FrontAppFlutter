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
    //Methode permettant de changer le role d'un user en admin ou admin en user.
    globals.ajoutadmin = '';
    globals.rolemod = '';
    Map data = {'role': 'admin'};

    await _getRole(nameCtrl.text);
    //appel _getRole() pour recupérer le role de l'utilisateur saisi par le pseudo
    if (globals.rolemod == '') {
      return 'FIN';
    }
    if (globals.rolemod == 'admin') {
      //test pour savoir quelle valeur donner à role en fonciton de son role acutel
      globals.ajoutadmin = 'User ' + nameCtrl.text + ' est passé user';
      data = {'role': 'user'};
    } else {
      globals.ajoutadmin = 'User ' + nameCtrl.text + ' est passé admin';
      data = {'role': 'admin'};
    }

    String bodyData = json.encode(data);
    // var url = 'http://10.0.2.2:5001/user/' + globals.user_idmod.toString();
    var url = 'http://172.16.18.27:5001/user/' + globals.user_idmod.toString();
    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json", "token": globals.token},
      body: bodyData,
    );
    return response.body;
  }

  Future<String> _getRole(String pseudo) async {
    // Récupère en fonction du pseudo l'id et le role d'un user.
    globals.ajoutadmin = '';
    //  var url = 'http://10.0.2.2:5001/user/' + pseudo;
    var url = 'http://172.16.18.27:5001/user/' + pseudo;
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json", "token": globals.token},
    );
    if (response.statusCode == 200) {
      final Map parsed = json.decode(response.body);

      globals.user_idmod = parsed['id'].toString();
      globals.rolemod = parsed['role'].toString();
    } else {
      globals.ajoutadmin = 'Pseudo inconnu!';
    }
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
            SizedBox(
              height: 15.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15),
              onPressed: () async {
                await _changeRole();

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
