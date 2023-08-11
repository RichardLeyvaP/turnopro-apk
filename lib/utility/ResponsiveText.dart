// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final double
      baseFontSize; // Tamaño de fuente base para una pantalla con ancho 360.
  final double
      scaleFactor; // Factor de escala para ajustar el tamaño de fuente según el ancho de la pantalla.

  // ignore: prefer_const_constructors_in_immutables
  ResponsiveText(
      {super.key,
      required this.text,
      required this.baseFontSize,
      this.scaleFactor = 0.5});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final adjustedFontSize = baseFontSize + (screenWidth - 360) * scaleFactor;

    return Text(
      text,
      style: TextStyle(fontSize: adjustedFontSize),
    );
  }
}
