// constants/constants.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  // App Strings
  static const String appName = "AM SocialMedia App";

  // Colors
  static const Color lightPrimary = Color(0xfff3f4f9);
  static const Color darkPrimary = Color(0xff2B2B2B);
  static const Color lightAccent = Color(0xff886EE4);
  static const Color darkAccent = Color(0xff886EE4);
  static const Color lightBG = Color(0xfff3f4f9);
  static const Color darkBG = Color(0xff2B2B2B);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: lightBG,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: lightPrimary,
      secondary: lightAccent,
      background: lightBG,
    ),
    textTheme: GoogleFonts.nunitoTextTheme().apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: lightAccent),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: darkBG,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkAccent,
      background: darkBG,
    ),
    textTheme: GoogleFonts.nunitoTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: darkAccent),
  );

  // Utility function for mapping
  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
}
