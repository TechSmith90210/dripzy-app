import 'package:dripzy/models/address/address_model.dart';
import 'package:flutter/material.dart';

class AddressTileWidget extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressTileWidget({
    super.key,
    required this.address,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color.primary : color.outline.withOpacity(.3),
            width: isSelected ? 1.6 : 1,
          ),
          color: isSelected ? color.primary.withOpacity(.06) : color.surface,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Label + default badge
                  Row(
                    children: [
                      _labelChip(context),
                      if (address.isDefault) ...[
                        const SizedBox(width: 6),
                        _defaultBadge(context),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  if (address.receiverName != null) ...[
                    Text(
                      address.receiverName!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: color.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                  ],

                  Text(
                    address.phone,
                    style: TextStyle(color: color.onSurfaceVariant),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _formattedAddress(),
                    style: TextStyle(height: 1.3, color: color.onSurface),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelChip(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        address.label,
        style: TextStyle(
          color: color.onSecondaryContainer,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _defaultBadge(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "DEFAULT",
        style: TextStyle(
          color: color.onPrimary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formattedAddress() {
    return [
      address.line1,
      if (address.line2 != null && address.line2!.isNotEmpty) address.line2,
      address.postalCode,
    ].join(', ');
  }
}
