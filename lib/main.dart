import 'dart:isolate';

import 'ui/user.dart';
import 'package:flutter/material.dart';
import 'ui/home.dart';

void main() async {
  runApp(
    new MaterialApp(
      title: "Codeforces",
      home: Home(),
    ),
  );
}
