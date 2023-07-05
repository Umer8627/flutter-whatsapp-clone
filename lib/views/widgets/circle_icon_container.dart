import 'package:flutter/material.dart';

class CircleIconContainer extends StatelessWidget {
  const CircleIconContainer({
    Key? key,
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final Color color;
  final Color iconColor;
  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 52,
        width: 53,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(
          color: iconColor,
          icon,
        ),
      ),
    );
  }
}
