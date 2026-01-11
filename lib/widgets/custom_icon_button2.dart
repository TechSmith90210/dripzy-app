import 'package:flutter/material.dart';

class CustomIconButton2 extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? bgColor;
  final Color? fgColor;

  const CustomIconButton2({super.key, required this.onPressed, this.icon, this.bgColor, this.fgColor});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? color.primary,
          foregroundColor: fgColor ?? color.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: color.primary.withValues(alpha: 0.1))
          ),
          padding:  EdgeInsets.symmetric(vertical: bgColor !=null ? 6 : 10),
        ).copyWith(
          // 👇 disables ripple & splash effects
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: icon != null ? 8 : 0,
          children: [Icon(icon,size: 25,)],
        ),
      ),
    );
  }
}
