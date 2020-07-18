import 'package:flutter/material.dart';
import 'package:flutter_project/view/home.dart';
import 'package:flutter_project/view/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
