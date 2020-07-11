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
          Icons.arrow_back_ios,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
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
