import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.iconSize,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.black45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
      padding: const EdgeInsets.all(8.0),
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
