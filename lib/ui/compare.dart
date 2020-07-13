import 'package:cf_view/ui/home.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Compare extends StatelessWidget {
  String handle1, handle2;

  Compare(handle1, handle2) {
    this.handle1 = handle1;
    this.handle2 = handle2;
  }

  TextEditingController _handle1Controller = TextEditingController();
  TextEditingController _handle2Controller = TextEditingController();

  _displayCompareDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Column(
              children: <Widget>[
                new TextField(
                  controller: _handle1Controller,
                  decoration: InputDecoration(hintText: "Handle1"),
                ),
                new TextField(
                  controller: _handle2Controller,
                  decoration: InputDecoration(hintText: "Handle2"),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Compare'),
                onPressed: () {
                  Navigator.of(context).pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      String handle1 = _handle1Controller.text.toString();
                      String handle2 = _handle2Controller.text.toString();
                      _handle1Controller.clear();
                      _handle2Controller.clear();
                      return Compare(handle1, handle2);
                    },
                  ));
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          "Compare Handles",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: new Image.asset(
          "assets/images/cf.png",
          height: 30.0,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
          )
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Padding(padding: const EdgeInsets.only(top: 20.0)),
          Center(
            child: Text("Under Development!"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: Icon(
            Icons.compare,
          ),
          onPressed: () => _displayCompareDialog(context)),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.black12,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.home,
                  color: Theme.of(context).accentColor,
                ),
                Text('Home')
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> getInformations(String userHandle) async {
  print("User handle " + userHandle);
  String apiUrl = "https://codeforces.com/api/user.info?handles=$userHandle";
  http.Response data = await http.get(apiUrl);
  return json.decode(data.body);
}
