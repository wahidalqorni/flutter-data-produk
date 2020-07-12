import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/modal/api.dart';
import 'package:flutter_project/view/home.dart';
import 'package:flutter_project/view/product.dart';
import 'package:flutter_project/view/profile.dart';
import 'package:flutter_project/view/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
    primaryColor: Colors.purple[800],
    accentColor: Colors.purple[600],
  ),
    home: Login(),
  ));
}

// Login Class
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  final _key = new GlobalKey<FormState>(); //untuk atribut form validation

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autovalidate = false;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      //print("$username, $password");
      login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  login() async {
    //fungsi login
    final response = await http.post(BaseUrl.login,
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String namaAPI = data['nama'];
    String usernameAPI = data['username'];
    String id = data['id'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, namaAPI, id);
      });
      print(message);
    } else {
      print(message);
    }
    // print(data);
  }

  savePref(int value, String username, String nama, String id) async {
    // buat saveData ke local db android
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("username", username);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    // get savePref dan kasihkan kondisi is_login or logout
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    // fungsi logout
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            title: Text("Login Page"),
          ),
          body: Form(
           autovalidate: _autovalidate,
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Insert username!";
                    } else if(!e.contains("@")){
                      return "Masukkan Email kamu untuk username";
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
                    }
                  },
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: showHide,
                        icon: Icon(_secureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )),
                ),
                MaterialButton(
                  onPressed: () {
                    check();
                  },
                  child: Text('Login'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text(
                    'Buat Akun di sini',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }
}

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
      appBar: AppBar(),
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
                } else if(!e.contains("@")){
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
                } else  if(p.length < 4) {
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
            MaterialButton(
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

// MainMenu Class
class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut(); //knapa widget? krn signOut berada dalam widget State
    });
  }

  String username = "", nama = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      nama = preferences.getString("nama");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Product App")),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.lock_open),
            )
          ],
          bottom: TabBar(
            indicatorColor: Colors.green,
            tabs: <Widget>[
              InkWell(
                child: FittedBox(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.home),
                      Text("Home"),
                    ],
                  ),
                ),
              ),
              InkWell(
                child: FittedBox(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.apps),
                      Text("Product"),
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Home(),
            Product(),
          ],
        ),
        bottomNavigationBar: TabBar(
            labelColor: Colors.purple[600],
            unselectedLabelColor: Colors.grey,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
            ),
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.apps),
                text: "Product",
              ),
              
            ]),
      ),
    );
  }
}
