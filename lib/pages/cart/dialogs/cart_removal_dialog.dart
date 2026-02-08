import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showClearCartDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  final color = Theme.of(context).colorScheme;

  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        "This will remove all items from your cart. Are you sure?",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: color.primary,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.pop();
            onConfirm();
          },
          child: Text(
            "Yes",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color.onPrimary,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () => context.pop(),
          child: Text(
            "No",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color.primary,
            ),
          ),
        ),
      ],
    ),
  );
}

