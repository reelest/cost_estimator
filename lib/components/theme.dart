/*
  Contains all the styles used by the application.
*/
import 'package:cost_estimator/components/hooks.dart';
import 'package:flutter/material.dart';

class GlobalTheme {
  static const TextStyle h1 = TextStyle(
      color: Colors.black87, fontSize: 36, fontWeight: FontWeight.bold);
  static const TextStyle description = TextStyle(
      color: Colors.black45, fontSize: 18, fontWeight: FontWeight.normal);

  static double getWindowPadding(BuildContext context) {
    return useBreakpoint({400: 32.0, 800: 64.0, 9999999: 128.0}, context);
  }

  static ButtonStyle getIntroButtonStyle(BuildContext context) => ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).primaryColor.withAlpha(64)),
        overlayColor: MaterialStateProperty.all<Color>(
            Theme.of(context).primaryColor.withAlpha(64)),
      );
  // Colors
  static const Color splashBackground = Color.fromARGB(255, 250, 253, 255);

  // ThemeData
  static ThemeData themeData = ThemeData(
      // This is the theme of your application.
      // primarySwatch: Colors.blue,
      primaryColor: Colors.blue);
}
