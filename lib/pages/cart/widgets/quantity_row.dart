import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../widgets/custom_circle_button.dart';
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onTapPlus;
  final VoidCallback onTapMinus;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onTapPlus,
    required this.onTapMinus,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28,
          width: 28,
          child: CustomCircleButton(
            icon: IconsaxPlusBroken.minus,
            onTap: onTapMinus,
            bgColor: color.surface,
            iconColor: color.primary,
          ),
        ),

        const SizedBox(width: 12),

        Text(
          quantity.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color.primary,
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          height: 28,
          width: 28,
          child: CustomCircleButton(
            icon: IconsaxPlusBroken.add,
            onTap: onTapPlus,
            bgColor: color.primary,
            iconColor: color.onPrimary,
          ),
        ),
      ],
    );
  }
}
