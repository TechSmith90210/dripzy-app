import 'package:flutter/material.dart';

Future<bool?> showLogoutDialog(
  BuildContext context, {
  required VoidCallback onLogoutClick,
  required VoidCallback onCancelClick,
}) {
  final color = Theme.of(context).colorScheme;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: color.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color.primary,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "You will need to login again to access your account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: color.onBackground.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: onCancelClick,
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: color.onBackground),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.error,
                        foregroundColor: color.onError,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onLogoutClick,
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
