import 'package:flutter/material.dart';
import 'package:flutter_app/MyApp.dart';
import 'package:flutter_app/MySecond.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MainApp()));

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home")),
        body: new ListView(
          children: <Widget>[
            Card(
              child: new InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(
                          Icons.person_add,
                          color: Colors.deepOrange,
                        ),
                        title: Text('Check Users'),
                      ),
                    ],
                  )),
            ),
            Card(
              child: new InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MySecond()),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.deepOrange,
                        ),
                        title: Text('Check Mat Details'),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
