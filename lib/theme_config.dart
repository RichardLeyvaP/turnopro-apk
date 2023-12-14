import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  // Colores para el tema de profesionales
  static const Color colorPrimario = const Color(0xFFF18254);
  static const Color colorSecundario = const Color.fromARGB(155, 231, 232, 234);

  // Colores para el tema de responsables
  static const Color colorPrimario2 = const Color.fromARGB(255, 26, 50, 82);
  static const Color colorSecundario2 = const Color.fromARGB(155, 36, 86, 185);

  static ThemeData getProfessionalTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        toolbarHeight: 120,
        backgroundColor: colorPrimario,
      ),
      primaryColor: colorPrimario,
      hintColor: colorSecundario,
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }

  static ThemeData getResponsibleTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        toolbarHeight: 120,
        backgroundColor: colorPrimario2,
      ),
      primaryColor: colorPrimario2,
      hintColor: colorSecundario2,
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }
}
