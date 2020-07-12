import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/modal/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {

  final VoidCallback reload;
  AddProduct(this.reload);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String namaProduk, qty, harga, idUsers;
  final _key = new GlobalKey<FormState>();

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id"); //ambil variabel id yg dibawah oleh shareprefrences saat login
    });
  }

  check(){
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      //print("$username, $password");
      submit();
    }
  }

  submit() async {
    final response = await http.post(BaseUrl.addProduct, body: {
        "namaProduk" : namaProduk,
        "qty"        : qty,
        "harga"      : harga,
        "idUsers"    : idUsers
      } 
    );

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if(value == 1) {
      print(message);
      setState(() {
        widget.reload;
        Navigator.pop(context);
      });
    } else {
      print(message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
              child: ListView(
                padding: EdgeInsets.all(16.0),
         children: <Widget>[
           TextFormField(
             validator: (e) {
                if (e.isEmpty) {
                  return "Insert Nama Produk!";
                }
              },
             onSaved: (e) => namaProduk = e,
             decoration: InputDecoration(
               labelText: "Nama Produk"
             ),
           ),
           
          TextFormField(
            validator: (e) {
                if (e.isEmpty) {
                  return "Insert Qty!";
                }
              },
             onSaved: (e) => qty = e,
             decoration: InputDecoration(
               labelText: "Qty"
             ),
           ),

           TextFormField(
             validator: (e) {
                if (e.isEmpty) {
                  return "Insert Harga!";
                }
              },
             onSaved: (e) => harga = e,
             decoration: InputDecoration(
               labelText: "Harga"
             ),
           ),
           MaterialButton(
             onPressed: (){
               check();
             },
             child: Text("Proses"),
           )
         ], 
        ),
      ),
    );
  }
}