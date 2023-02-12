import 'package:cost_estimator/components/theme.dart';
import 'package:cost_estimator/screens/home/main.dart';
import 'package:cost_estimator/screens/intro/main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cost Estimator',
        theme: GlobalTheme.themeData,
        routes: <String, WidgetBuilder>{
          '/': (context) => const IntroScreen(title: "Introduction"),
          '/home': (context) => const HomeScreen(title: "Enter parameters")
        });
  }
}
