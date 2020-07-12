import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/custom/currency.dart';
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

  setup() {
    txtNama = TextEditingController(text: widget.model.namaProduk);
    txtQty = TextEditingController(text: widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    final response = await http.post(BaseUrl.editProduct, body: {
      "namaProduk": namaProduk,
      "qty": qty,
      "harga": harga.replaceAll(",", ""),
      "id": widget.model.id
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
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
      appBar: AppBar(
        title: Text("Edit Data Produk"),
      ),
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
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),
            TextFormField(
              controller: txtQty,
              validator: (e) {
                if (e.isEmpty) {
                  return "Insert Qty!";
                }
              },
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: "Qty"),
            ),
            TextFormField(
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              controller: txtHarga,
              validator: (e) {
                if (e.isEmpty) {
                  return "Insert Harga!";
                }
              },
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: "Harga"),
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
              child: Text("Proses"),
            )
          ],
        ),
      ),
    );
  }
}
