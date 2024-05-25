import 'package:flutter/material.dart';

class TruncatedText extends StatelessWidget {
  final String text;
  final int maxLength;
  final TextStyle styleText;

  TruncatedText(
      {required this.text, required this.maxLength, required this.styleText});

  @override
  Widget build(BuildContext context) {
    return Text(
      _truncateText(text, maxLength),
      style: styleText,
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + '..';
    }
  }
}
