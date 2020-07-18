import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/modal/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Register Class
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username, password, nama;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var validate = true;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      //print("$username, $password");
      save();
    } else {
      setState(() {
        validate = true;
      });
    }
  }

  save() async {
    // fungsi save registrasi
    final response = await http.post(BaseUrl.register,
        body: {"username": username, "password": password, "nama": nama});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      body: Form(
        autovalidate: validate,
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (n) {
                if (n.isEmpty) {
                  return "Insert Nama!";
                }
              },
              onSaved: (n) => nama = n,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Insert username!";
                } else if (!e.contains("@")) {
                  return "Masukkan email kamu untuk username";
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextFormField(
              obscureText: _secureText,
              validator: (p) {
                if (p.isEmpty) {
                  return "Insert password!";
                } else if (p.length < 4) {
                  return "Password minimal 4 karakter";
                }
              },
              onSaved: (e) => password = e,
              decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(
                        _secureText ? Icons.visibility_off : Icons.visibility),
                  )),
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
              color: Colors.purple[800],
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.purpleAccent,
              onPressed: () {
                check();
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
