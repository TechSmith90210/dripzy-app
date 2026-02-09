import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../widgets/custom_icon_button2.dart';

class ProductQuantityControls extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductQuantityControls({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: CustomIconButton2(
            icon: IconsaxPlusBroken.minus,
            onPressed: onDecrement,
            bgColor: color.surface,
            fgColor: color.primary,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: color.onPrimary.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              quantity.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color.primary,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          flex: 2,
          child: CustomIconButton2(
            icon: IconsaxPlusBroken.add,
            onPressed: onIncrement,
            bgColor: color.tertiary,
            fgColor: color.primary,
          ),
        ),
      ],
    );
  }
}
