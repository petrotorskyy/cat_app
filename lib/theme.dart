import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: Color.fromARGB(255, 40, 198, 0),
  primaryColorLight: const Color(0xFFe0e0e0),
  primaryColor: const Color.fromARGB(255, 40, 198, 0),
  colorScheme: const ColorScheme.light(secondary: Color(0xFF009688)),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
