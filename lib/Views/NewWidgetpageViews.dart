import 'package:flutter/material.dart';

class NewWidgetpageViews extends StatelessWidget {
  const NewWidgetpageViews({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.blue,
            child: Row(
              children: [
                Text('First Page'),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.red,
            child: Row(
              children: [
                Text('First Page'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
