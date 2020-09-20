import 'compare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import './user.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviousContests extends StatefulWidget {
  int bal = 0;
  PreviousContests(int bal) {
    this.bal = bal;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();
    return PreviousContestsState(bal);
  }
}

class PreviousContestsState extends State {
  int bal;
  PreviousContestsState(int bal) {
    this.bal = bal++;
  }

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _handle1Controller = TextEditingController();
  TextEditingController _handle2Controller = TextEditingController();

  _launchURL(int id) async {
    String url = "https://codeforces.com/contest/" + id.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _displaySearchDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Search CF user Handle'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Handle"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Search'),
                onPressed: () {
                  Navigator.of(context).pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      String handle = _textFieldController.text.toString();
                      _textFieldController.clear();
                      return User(handle);
                    },
                  ));
                },
              ),
            ],
          );
        });
  }

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
                      // _handle1Controller.clear();
                      // _handle2Controller.clear();
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
          "Previous Contests",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: new Image.asset(
          "assets/images/cf.png",
          height: 25.0,
          // width: 20.0,
        ),
      ),
      body: new FutureBuilder(
          future: contestInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: snapshot.data['result'].length,
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    index += bal + 1;
                    print("bal : $bal");
                    if (snapshot.data['result'][index]['phase'] == "FINISHED") {
                      print("Index : $index");
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 2,
                              offset:
                                  Offset(2, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: InkWell(
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Name",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "Type",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "Duration",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "Start",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                              new VerticalDivider(),
                              new Column(
                                children: <Widget>[
                                  Text(":"),
                                  Text(":"),
                                  Text(":"),
                                  Text(":"),
                                ],
                              ),
                              new VerticalDivider(),
                              new Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data['result'][index]['name'],
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      snapshot.data['result'][index]['type'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      // duration(snapshot.data['result'][index]
                                      //     ['durationSeconds']),
                                      ((snapshot.data['result'][index]
                                                      ['durationSeconds']) /
                                                  (60 * 60))
                                              .toString() +
                                          " hr",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      startTime(snapshot.data['result'][index]
                                          ['startTimeSeconds']),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          onTap: () =>
                              _launchURL(snapshot.data['result'][index]['id']),
                        ),
                      );
                    }
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: Icon(
            Icons.search,
          ),
          onPressed: () => _displaySearchDialog(context)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.new_releases,
                color: Colors.grey,
              ),
              title: Text(
                "UPCOMING",
                style: TextStyle(color: Colors.grey),
              ),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.update,
                color: Colors.blue,
              ),
              title: Text(
                "PREVIOUS",
                style: TextStyle(color: Colors.blue),
              ),
              backgroundColor: Colors.blueGrey),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare),
            title: Text("COMPARE"),
          ),
        ],
        onTap: (value) {
          if (value == 0) {
            Navigator.pop(context);
          }
          // else if (value == 1) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => PreviousContests(this.bal)),
          //   );
          // }
          else if (value == 2) {
            _displayCompareDialog(context);
          }
        },
      ),
    );
  }
}

Future<Map<String, dynamic>> contestInfo() async {
  String url = "https://codeforces.com/api/contest.list";
  http.Response data = await http.get(url);
  return json.decode(data.body);
}

String startTime(timestamp) {
  var format = new DateFormat('EEE dMMMM y HH:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var time = format.format(date);
  return time;
}

String duration(timestamp) {
  double h, min = 0;
  if (timestamp % 3600 == 0)
    h = (timestamp / 3600);
  else {
    h = timestamp % 3600;
    timestamp = timestamp - (timestamp * h);
    min = timestamp;
  }

  return h.toString() + 'hr ' + min.toString() + 'min';
}
