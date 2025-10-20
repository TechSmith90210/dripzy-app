import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final double size; // diameter of the circle
  final VoidCallback onTap;

  const CustomCircleButton({
    super.key,
    required this.bgColor,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: onTap,
        child: Icon(
          icon,
          size: 24,
          color: iconColor,
        ),
      ),
    );
  }
}
