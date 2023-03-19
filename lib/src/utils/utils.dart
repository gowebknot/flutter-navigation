extension DurationExtension on int {
  Duration get sec => Duration(seconds: this);
  Duration get ms => Duration(milliseconds: this);
}
