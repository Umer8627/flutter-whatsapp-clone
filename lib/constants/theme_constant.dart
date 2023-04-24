import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/color_constant.dart';

ThemeData getTheme() {
  return ThemeData(
    fontFamily: "monstserrat",
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
    ),
   
    primarySwatch: const MaterialColor(0xFF075e54, <int, Color>{
      50: Color(0xFF06554c),
      100: Color(0xFF064b43),
      200: Color(0xFF05423b),
      300: Color(0xFF043832),
      400: Color(0xFF042f2a),
      500: Color(0xFF032622),
      600: Color(0xFF021c19),
      700: Color(0xFF011311),
      800: Color(0xFF010908),
      900: Color(0xFF000000),
    }),
  );
}

class CustomFont {
  static const boldText = TextStyle(
    fontSize: 25,
    fontFamily: 'monstserrat',
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    color: Colors.white,
    letterSpacing: 0,
    // height: 1.1,
  );
  static const mediumText = TextStyle(
    fontSize: 25,
    fontFamily: 'monstserrat',
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    color: Colors.white,
    letterSpacing: 0,
    height: 1.2,
  );
  static const regularText = TextStyle(
    fontSize: 15,
    fontFamily: 'monstserrat',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: Colors.white,
    letterSpacing: 0,
    height: 1.2,
  );
  static const lightText = TextStyle(
    fontSize: 12,
    fontFamily: 'monstserrat',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0,
    // height: 1.1,
  );
}
