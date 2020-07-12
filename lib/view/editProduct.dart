import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/modal/api.dart';
import 'package:flutter_project/modal/productModel.dart';
import 'package:http/http.dart' as http;

class EditProduct extends StatefulWidget {
  final ProductModel model;
  final VoidCallback reload;
  EditProduct(this.model, this.reload);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _key = new GlobalKey<FormState>();
  String namaProduk, qty, harga;

  TextEditingController txtNama, txtQty, txtHarga;

  setup(){
    txtNama = TextEditingController(text: widget.model.namaProduk);
    txtQty = TextEditingController(text: widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);
  }

  check(){
    final form = _key.currentState;
    if(form.validate()){
      form.save();
      submit();
    } else {

    }
  }

  submit()async{
    final response = await http.post(BaseUrl.editProduct, body:{
      "namaProduk" : namaProduk,
      "qty"        : qty,
      "harga"      : harga,
      "id"         : widget.model.id
    }); 
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if(value == 1) {
      setState(() {
        widget.reload();
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
    setup();
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
             controller: txtNama,
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
            controller: txtQty,
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
             controller: txtHarga,
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