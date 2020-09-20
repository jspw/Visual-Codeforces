import 'package:cf_view/ui/home.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';

class User extends StatelessWidget {
  String userHandle;
  User(textFieldController) {
    this.userHandle = textFieldController;
  }

  TextEditingController _textFieldController = TextEditingController();

  Future<Map<String, dynamic>> getInformations(String userHandle) async {
    print("User handle " + userHandle);
    String apiUrl = "https://codeforces.com/api/user.info?handles=$userHandle";
    http.Response data = await http.get(apiUrl);

    return json.decode(data.body);
  }

  Future<List<dynamic>> contestRating(String userHandle) async {
    print("User handle in contest Rating" + userHandle);

    String contestRatingUrl =
        "https://codeforces.com/api/user.rating?handle=$userHandle";
    http.Response contestRating = await http.get(contestRatingUrl);

    return ((json.decode(utf8.decode(contestRating.bodyBytes)))['result']);
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('H:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    // Online ?
    if (diff.inMinutes == 0)
      time = "Online";

    // Less then day ?
    else if (diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    }

    // days ?

    else if (diff.inDays >= 1 && diff.inDays < 7) {
      if (diff.inDays == 1)
        time = diff.inDays.toString() + ' Day ago';
      else
        time = (diff.inDays).toString() + ' Days ago';
    }

    // Weeks  ?

    else if (diff.inDays >= 7 && diff.inDays < 30) {
      if (diff.inDays == 7)
        time = '1 Week ago';
      else
        time = (diff.inDays / 7).floor().toString() + ' Weeks ago';
    }

    // Months  ?

    else if (diff.inDays >= 30 && diff.inDays < 356) {
      if (diff.inDays == 30)
        time = '1 Month ago';
      else
        time = (diff.inDays / 30).floor().toString() + ' Months ago';
    }

    // Years  ?
    else {
      if (diff.inDays == 356)
        time = '1 Year ago';
      else
        time = (diff.inDays / 365).floor().toString() + ' Years ago';
    }

    return time;
  }

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
                      // _textFieldController.clear();
                      return User(handle);
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
          height: 25.0,
        ),
      ),
      body: new ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          new Padding(padding: const EdgeInsets.only(top: 20.0)),
          new FutureBuilder(
              future: Future.wait([
                getInformations(userHandle),
                contestRating(userHandle),
              ]),
              builder: (context, snapshot) {
                print('Snapshot data :  ${snapshot.data}');

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
                  if (snapshot.data[0]["status"] == 'OK') {
                    ///
                    ///
                    ////parsing contest rating data!
                    ///
                    ///
                    ///

                    List<double> contestRatingData = new List();

                    for (int i = 0; i < snapshot.data[1].length; i++) {
                      contestRatingData
                          .add((snapshot.data[1][i]['newRating']) / 1.0);
                    }

                    print("List : $contestRatingData");

                    //

                    String lastName =
                        snapshot.data[0]["result"][0]['lastName'] == null
                            ? ""
                            : snapshot.data[0]["result"][0]['lastName'];

                    String country =
                        snapshot.data[0]["result"][0]['country'] == null
                            ? ""
                            : snapshot.data[0]["result"][0]['country'];

                    int lastOnlineTimeSeconds = snapshot.data[0]["result"][0]
                                ['lastOnlineTimeSeconds'] ==
                            null
                        ? 0
                        : snapshot.data[0]["result"][0]
                            ['lastOnlineTimeSeconds'];

                    var lastOnlineTime = readTimestamp(lastOnlineTimeSeconds);
                    print(lastOnlineTime);

                    String city = snapshot.data[0]["result"][0]['city'] == null
                        ? ""
                        : snapshot.data[0]["result"][0]['city'];

                    int rating = snapshot.data[0]["result"][0]['rating'] == null
                        ? 0
                        : snapshot.data[0]["result"][0]['rating'];

                    int friendOfCount =
                        snapshot.data[0]["result"][0]['friendOfCount'] == null
                            ? 0
                            : snapshot.data[0]["result"][0]['friendOfCount'];
                    String titlePhoto =
                        snapshot.data[0]["result"][0]['titlePhoto'] == null
                            ? ""
                            : snapshot.data[0]["result"][0]['titlePhoto'];
                    String handle =
                        snapshot.data[0]["result"][0]['handle'] == null
                            ? ""
                            : snapshot.data[0]["result"][0]['handle'];
                    String avatar =
                        snapshot.data[0]["result"][0]['avatar'] == null
                            ? ""
                            : snapshot.data[0]["result"][0]['avatar'];
                    String firstName =
                        snapshot.data[0]["result"][0]['firstName'] == null
                            ? ""
                            : snapshot.data[0]["result"][0]['firstName'];
                    int contribution =
                        snapshot.data[0]["result"][0]['contribution'] == null
                            ? 0
                            : snapshot.data[0]["result"][0]['contribution'];
                    String organization =
                        snapshot.data[0]["result"][0]['organization'] == null
                            ? ""
                            : snapshot.data[0]["result"][0]['organization'];

                    String rank = snapshot.data[0]["result"][0]['rank'] == null
                        ? ""
                        : snapshot.data[0]["result"][0]['rank'];

                    int maxRating =
                        snapshot.data[0]["result"][0]['maxRating'] == null
                            ? 0
                            : snapshot.data[0]["result"][0]['maxRating'];

                    int registrationTimeSeconds = snapshot.data[0]["result"][0]
                                ['registrationTimeSeconds'] ==
                            null
                        ? 0
                        : snapshot.data[0]["result"][0]
                            ['registrationTimeSeconds'];

                    var registrationTime =
                        readTimestamp(registrationTimeSeconds);
                    print("Registration : $registrationTime");

                    String maxRank =
                        snapshot.data[0]["result"][0]['maxRank'] == null
                            ? ""
                            : snapshot.data[0]["result"][0]['maxRank'];

                    return StaggeredGridView.count(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      crossAxisCount: 4,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 20.0,
                      padding: const EdgeInsets.all(10.0),
                      children: <Widget>[
                        // Container(
                        //   alignment: Alignment.topRight,
                        //   child: Text(
                        //     "Profile",
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 18.0,
                        //     ),
                        //     textAlign: TextAlign.right,
                        //   ),
                        // ),
                        Material(
                          color: Colors.white,
                          elevation: 5.0,
                          shadowColor: Colors.green,
                          borderRadius: BorderRadius.circular(0.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          padding:
                                              const EdgeInsets.only(top: 20.0)),
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
                                            decoration:
                                                TextDecoration.underline,
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
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ])),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0)),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.rate_review,
                                              color: Colors.blue),
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
                                          padding:
                                              const EdgeInsets.only(top: 10.0)),
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
                                          padding:
                                              const EdgeInsets.only(top: 10.0)),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                          Text(
                                              " Friend of: $friendOfCount users"),
                                        ],
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0)),
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
                                          padding:
                                              const EdgeInsets.only(top: 5.0)),
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
                                // new Card(
                                //   shadowColor: Colors.grey,
                                //   child:
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  // decoration: BoxDecoration(
                                  //     shape: BoxShape.rectangle,
                                  //     border: Border.all(
                                  //       width: 1.0,
                                  //       color: Colors.grey,
                                  //     )),
                                  alignment: Alignment.topRight,
                                  child: new Image.network(
                                    "https:" + avatar,
                                    // width: 120.0,
                                  ),
                                ),
                                // )
                              ],
                            ),
                          ),
                        ),

                        //Circle Graph!

                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Material(
                        //     color: Colors.white,
                        //     elevation: 5,
                        //     // borderOnForeground: false ,
                        //     borderRadius: BorderRadius.circular(0.0),
                        //     shadowColor: Colors.grey,
                        //     // child: new Padding(
                        //     //   padding: const EdgeInsets.all(10.0),
                        //     child: Container(
                        //       alignment: Alignment.center,
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: <Widget>[
                        //           //chart
                        //           Padding(
                        //             padding: const EdgeInsets.all(1.0),
                        //             child: AnimatedCircularChart(
                        //               size: const Size(100, 100),
                        //               initialChartData: [
                        //                 new CircularStackEntry(
                        //                   <CircularSegmentEntry>[
                        //                     new CircularSegmentEntry(
                        //                         700.0, Color(0xff4285F4),
                        //                         rankKey: 'Q1'),
                        //                     new CircularSegmentEntry(
                        //                         1000.0, Color(0xfff3af00),
                        //                         rankKey: 'Q2'),
                        //                     new CircularSegmentEntry(
                        //                         1800.0, Color(0xffec3337),
                        //                         rankKey: 'Q3'),
                        //                     new CircularSegmentEntry(
                        //                         1000.0, Color(0xff40b24b),
                        //                         rankKey: 'Q4'),
                        //                   ],
                        //                   rankKey: 'Quarterly Profits',
                        //                 ),
                        //               ],
                        //               chartType: CircularChartType.Pie,
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // // ),

                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Material(
                            color: Colors.white,
                            elevation: 5,
                            // borderOnForeground: false ,
                            borderRadius: BorderRadius.circular(0.0),
                            shadowColor: Colors.grey,
                            // child: Padding(
                            // padding: const EdgeInsets.all(1.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Contest Informations",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                      // shadows: [
                                      //   Shadow(
                                      //     offset: Offset(1.0, 1.0),
                                      //     blurRadius: 3.0,
                                      //     color: Colors.grey,
                                      //   ),
                                      // ]
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0,top:5.0),
                                          child: new Text(
                                            "Total Contests",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0,top:5.0),
                                          child: new Text(
                                            "Lowest",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0,top:5.0),
                                          child: new Text(
                                            "Highest",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.red,
                                                shadows: []),
                                          ),
                                        )
                                      ],
                                    ),
                                    VerticalDivider(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0,top:5.0),
                                          child: new Text(
                                            ":",
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0,top:5.0),
                                          child: new Text(
                                            ":",
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0,top:5.0),
                                          child: new Text(
                                            ":",
                                          ),
                                        )
                                      ],
                                    ),
                                    VerticalDivider(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0,top:5.0),
                                          child: new Text(
                                            contestRatingData.length.toString(),
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0,top:5.0),
                                          child: new Text(
                                            (((contestRatingData.reduce(
                                                    (curr, next) => curr < next
                                                        ? curr
                                                        : next)).round())
                                                .toString()),
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0,top:5.0),
                                          child: new Text(
                                            (((contestRatingData.reduce(
                                                    (curr, next) => curr > next
                                                        ? curr
                                                        : next)).round())
                                                .toString()),
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.red,
                                                shadows: []),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  alignment: Alignment.center,
                                  child: Text("Rating Curve",style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0,
                                  ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 5.0),
                                  child: Sparkline(
                                    data: contestRatingData.isEmpty
                                        ? [0.0]
                                        : contestRatingData,
                                    lineColor: Colors.yellow,
                                    pointsMode: PointsMode.all,
                                    pointColor: Colors.red,
                                    pointSize: 4.0,
                                    // fillGradient: LinearGradient(colors: [
                                    //   Colors.tealAccent,
                                    //   Colors.indigo,
                                    //   Colors.grey,
                                    //   Colors.deepOrange,
                                    //   Colors.lime,
                                    //   Colors.deepPurple,
                                    //   Colors.lightGreen,
                                    //   Colors.blueAccent
                                    // ]),
                                    // fillMode: FillMode.below,
                                  ),
                                ),
                                // Divider(
                                //   // color: Colors.black,
                                //   // thickness: 1.0,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      staggeredTiles: [
                        StaggeredTile.extent(4, 320),
                        // StaggeredTile.extent(2, 200),
                        // StaggeredTile.extent(2, 200),
                        StaggeredTile.extent(4, 300),
                      ],
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
            Icons.search,
          ),
          onPressed: () => _displayDialog(context)),
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
