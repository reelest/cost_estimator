/*
  Contains all the styles used by the application.
*/
import 'package:flutter/material.dart';

class GlobalTheme {
  static const TextStyle h1 = TextStyle(
      color: Colors.black87, fontSize: 36, fontWeight: FontWeight.bold);
  static const TextStyle description = TextStyle(
      color: Colors.black45, fontSize: 18, fontWeight: FontWeight.normal);

  // Colors
  static const Color splashBackground = Color.fromARGB(255, 250, 253, 255);

  // ThemeData
  static ThemeData themeData = ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      // primarySwatch: Colors.blue,
      primaryColor: Colors.blue);
}
