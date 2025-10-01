import 'package:flutter/material.dart';

class CustomButton1 extends StatelessWidget {
  final Color bgColor;
  final String text;
  final VoidCallback onTap;

  const CustomButton1({
    super.key,
    required this.bgColor,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.primary,
          foregroundColor: color.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
