import 'package:intl/intl.dart';

int currentTimeInSeconds() {
  var ms = (new DateTime.now()).millisecondsSinceEpoch;
  return (ms / 1000).round();
}

void readTimestamp(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('H:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = now.difference(date);
  var time = '';

  print(diff.inSeconds);
}

void main() {
  print(currentTimeInSeconds());
  readTimestamp(1595601300);
  print(1595601300 - currentTimeInSeconds());
}
