import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      primarySwatch: Colors.blueGrey,
      brightness: Brightness.dark,
    );
  }
}
