import 'package:flutter/material.dart';

/*
  Returns whether the context is a mobile context. 
*/
bool useMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

/*
  Returns a value based on screen size
 */
T useBreakpoint<T>(Map<num, T> breakpoints, BuildContext context) {
  final windowWidth = MediaQuery.of(context).size.width;
  return breakpoints[breakpoints.keys.firstWhere((e) => windowWidth < e)] as T;
}
