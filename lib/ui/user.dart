import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class User extends StatelessWidget {
  String userHandle;
  User(textFieldController) {
    this.userHandle = textFieldController;
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
          userHandle,
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
          new FutureBuilder(
              future: getInformations(userHandle),
              builder: (context, snapshot) {
                if (snapshot.data == null)
                  return Center(
                    child: new Text(
                      "Searching .........",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20.0,
                      ),
                    ),
                  );
                else {
                  if (snapshot.data["status"] == 'OK') {
                    String lastName =
                        snapshot.data["result"][0]['lastName'] == null
                            ? ""
                            : snapshot.data["result"][0]['lastName'];

                    String country =
                        snapshot.data["result"][0]['country'] == null
                            ? ""
                            : snapshot.data["result"][0]['country'];

                    int lastOnlineTimeSeconds = snapshot.data["result"][0]
                                ['lastOnlineTimeSeconds'] ==
                            null
                        ? 0
                        : snapshot.data["result"][0]['lastOnlineTimeSeconds'];

                    var lastOnlineTime = readTimestamp(lastOnlineTimeSeconds);
                    print(lastOnlineTime);

                    String city = snapshot.data["result"][0]['city'] == null
                        ? ""
                        : snapshot.data["result"][0]['city'];

                    int rating = snapshot.data["result"][0]['rating'] == null
                        ? 0
                        : snapshot.data["result"][0]['rating'];

                    int friendOfCount =
                        snapshot.data["result"][0]['friendOfCount'] == null
                            ? 0
                            : snapshot.data["result"][0]['friendOfCount'];
                    String titlePhoto =
                        snapshot.data["result"][0]['titlePhoto'] == null
                            ? ""
                            : snapshot.data["result"][0]['titlePhoto'];
                    String handle = snapshot.data["result"][0]['handle'] == null
                        ? ""
                        : snapshot.data["result"][0]['handle'];
                    String avatar = snapshot.data["result"][0]['avatar'] == null
                        ? ""
                        : snapshot.data["result"][0]['avatar'];
                    String firstName =
                        snapshot.data["result"][0]['firstName'] == null
                            ? ""
                            : snapshot.data["result"][0]['firstName'];
                    int contribution =
                        snapshot.data["result"][0]['contribution'] == null
                            ? 0
                            : snapshot.data["result"][0]['contribution'];
                    String organization =
                        snapshot.data["result"][0]['organization'] == null
                            ? ""
                            : snapshot.data["result"][0]['organization'];

                    String rank = snapshot.data["result"][0]['rank'] == null
                        ? ""
                        : snapshot.data["result"][0]['rank'];

                    int maxRating =
                        snapshot.data["result"][0]['maxRating'] == null
                            ? 0
                            : snapshot.data["result"][0]['maxRating'];

                    int registrationTimeSeconds = snapshot.data["result"][0]
                                ['registrationTimeSeconds'] ==
                            null
                        ? 0
                        : snapshot.data["result"][0]['registrationTimeSeconds'];

                    var registrationTime =
                        readTimestamp(registrationTimeSeconds);
                    print("Registration : $registrationTime");

                    String maxRank =
                        snapshot.data["result"][0]['maxRank'] == null
                            ? ""
                            : snapshot.data["result"][0]['maxRank'];

                    return Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  rank,
                                  style: new TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  handle,
                                  style: new TextStyle(
                                    color: Colors.grey,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 20.0)),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: "$firstName $lastName, ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "$city, $country",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ])),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: "From ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "$organization",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ])),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10.0)),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.rate_review, color: Colors.blue),
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      children: <Widget>[
                                        RichText(
                                          softWrap: true,
                                          text: TextSpan(
                                            text: "",
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "Contest rating: ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "$rating ",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                RichText(
                                  textAlign: TextAlign.right,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: "(max. ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "$maxRank, $maxRating)",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10.0)),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.blue,
                                    ),
                                    RichText(
                                      softWrap: true,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: "Contribution: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "$contribution",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10.0)),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    Text(" Friend of: $friendOfCount users"),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10.0)),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: "Last visit: ",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "$lastOnlineTime",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ])),
                                Padding(
                                    padding: const EdgeInsets.only(top: 5.0)),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: "Registered: ",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "$registrationTime",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ])),
                              ],
                            ),
                          ),
                          new Card(
                            shadowColor: Colors.grey,
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    width: 1.0,
                                    color: Colors.grey,
                                  )),
                              alignment: Alignment.topRight,
                              child: new Image.network(
                                "https:" + titlePhoto,
                                width: 120.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else
                    return new Center(
                      child: new Text(
                        "Please enter a valid handle!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                    );
                }
              })
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

String readTimestamp(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('HH:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' DAY AGO';
    } else {
      time = diff.inDays.toString() + ' DAYS AGO';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
    } else {
      time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
    }
  }

  return time;
}
