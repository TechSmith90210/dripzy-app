import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomAlert {
  static void show(
    BuildContext context, {
    required String message,
    ToastificationType type = ToastificationType.success,
    AlignmentGeometry alignment = Alignment.topLeft,
  }) {
    final color = Theme.of(context).colorScheme;
    toastification.show(
      animationDuration: Duration(milliseconds: 180),
      context: context,
      title: Text(message),
      type: type,
      autoCloseDuration: const Duration(seconds: 2),
      alignment: alignment,
      backgroundColor: color.primary,
      primaryColor: color.onPrimary,
      foregroundColor: color.onPrimary
    );
  }
}
