import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final bool isExpanded;

  const ExpandableTextWidget({Key? key, required this.text, required this.isExpanded}) : super(key: key);

  @override
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: widget.isExpanded ? null : 1, // Si expandido, sin límite; si no, solo 1 línea
          overflow: widget.isExpanded ? null : TextOverflow.ellipsis, // Muestra puntos suspensivos si el texto es largo
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
