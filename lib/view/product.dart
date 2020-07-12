import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/modal/api.dart';
import 'package:flutter_project/modal/productModel.dart';
import 'package:flutter_project/view/addProduct.dart';
import 'package:flutter_project/view/editProduct.dart';
import 'package:http/http.dart' as http;

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  var loading = false;
  final list = new List<ProductModel>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
 Future<void> _listData() async { //Future<void> agar refresh swipe oke
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.listProduct);
    if (response.contentLength == 2) {
      
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new ProductModel(
          api['id'],
          api['namaProduk'],
          api['qty'],
          api['harga'],
          api['createdDate'],
          api['idUsers'],
          api['nama'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _listData,
        key: _refresh,
              child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                x.namaProduk,
                                style: TextStyle(
                                    fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              Text('Qty : '+ x.qty),
                              Text('Harga : '+ x.harga),
                              Text('Insert By : '+ x.nama),
                              Text('Created Date : '+ x.createdDate),
                            ],
                          ),
                        ),
                        IconButton(icon: Icon(Icons.edit), onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProduct(x, _listData) ));
                        },),
                        IconButton(icon: Icon(Icons.delete), onPressed: (){},)
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddProduct(_listData)));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
