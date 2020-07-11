import 'package:cf_view/ui/previous_contests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import './user.dart';
import 'compare.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();
    return HomeState();
  }
}

class HomeState extends State {
  // lOCAL pUSH NOTIFICATION

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState() {
    super.initState();
    initializing();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');

    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotifications() async {
    await notification();
  }

  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hello there', 'You have Upcoming Contests', notificationDetails);
  }

  Future<void> notificationAfterSec() async {
    var timeDelayed = DateTime.now().add(Duration(seconds: 10));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(1, 'Hello Coder!',
        'You have Upcoming Contests', timeDelayed, notificationDetails);
  }

  Future onSelectNotification(String payLoad) async {
    if (payLoad != null) {
      print("payLoad : $payLoad");
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => User(_textFieldController.text.toString())),
    );

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _handle1Controller = TextEditingController();
  TextEditingController _handle2Controller = TextEditingController();
  int bal = 0;

  _displayDialog(BuildContext context) async {
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
          "Upcoming Contests",
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
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: null)
        ],
      ),
      body: new FutureBuilder(
          future: contestInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  "Loading data.......",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25.0,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data['result'].length,
                // ignore: missing_return
                itemBuilder: (context, index) {
                  if (snapshot.data['result'][index]['phase'] == "BEFORE") {
                    this.bal = index;
                    print("Check : $bal");
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
                            offset: Offset(2, 1), // changes position of shadow
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
                        onTap: _showNotificationsAfterSecond,
                      ),
                    );
                  }
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: Icon(
            Icons.search,
          ),
          onPressed: () => _displayDialog(context)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            title: Text("UPCOMING"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            title: Text("PREVIOUS"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare),
            title: Text("COMPARE"),
          ),
        ],
        onTap: (value) {
          if (value == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else if (value == 1) {
            // print("h, bal $bal");
            bal++;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PreviousContests(this.bal)),
            );
          } else if (value == 2) {
            _displayCompareDialog(context);
          }
          ;
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
