import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Match widget.
///
/// If it is currently selected, then it is colored dark,
/// otherwise it is light.
class Match extends StatelessWidget {
  /// Is match currently selected
  final bool selected;

  const Match({
    Key? key,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.brown,
          ),
          width: 12.0,
          height: 12.0,
        ),
        Container(
          color: selected ? Colors.amber.shade800 : Colors.amber.shade300,
          width: 8.0,
          height: 64.0,
        ),
      ],
    );
  }
}
