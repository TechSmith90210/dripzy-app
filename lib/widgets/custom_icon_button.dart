import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const CustomIconButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color.primary,
            foregroundColor: color.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ).copyWith(
            // 👇 disables ripple & splash effects
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: icon != null ? 8 : 0,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (icon != null) Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
}
