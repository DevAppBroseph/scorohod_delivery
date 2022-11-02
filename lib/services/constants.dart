import 'package:delivery/services/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Api url
const String apiUrl = "https://server.scorohod.shop/";
//Token
const String authToken =
    '08v3v5028vn0q3498f1h03r9v1j304f98j23d913nf02498b29b04bg8u2v09b';

//Font
TextStyle accentFont = GoogleFonts.josefinSans(
    color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500);
//Border Radius
const BorderRadius radius = BorderRadius.all(
  Radius.circular(10),
);

//Convert Last Word
String convertOrders(String value) {
  switch (value.lastChars(1)) {
    case '0':
      return '$value заказов';
    case '1':
      return '$value заказ';
    case '2':
      return '$value заказа';
    case '3':
      return '$value заказа';
    case '4':
      return '$value заказа';
  }
  return '$value заказов';
}

//Shadow
final List<BoxShadow> shadow = [
  BoxShadow(
      color: const Color.fromARGB(255, 214, 214, 214).withOpacity(0.4),
      blurRadius: 10,
      offset: const Offset(0, 5)),
];

//Light Theme
final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  backgroundColor: const Color(0xFFFBFBFB),
  scaffoldBackgroundColor: Color(0xFFFBFBFB),
  cardColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFBFBFB),
    foregroundColor: Colors.black,
    shadowColor: Colors.black.withOpacity(0.2),
    titleTextStyle: GoogleFonts.josefinSans(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
  ),
  textTheme: TextTheme().apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
);

//Dark Theme
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.grey[900],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    shadowColor: Colors.black.withOpacity(0.2),
    titleTextStyle: GoogleFonts.raleway(
      color: Colors.white,
      fontSize: 18,
    ),
  ),
  textTheme: TextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
);
