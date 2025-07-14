extension Conversion on DateTime {
  int secondsSinceEpoch() => millisecondsSinceEpoch ~/ 1000;
}
