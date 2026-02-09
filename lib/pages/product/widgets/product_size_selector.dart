import 'package:flutter/material.dart';
import '../../../widgets/custom_alert.dart';

class ProductSizeSelector extends StatelessWidget {
  final List<String> availableSizes;
  final List<String> predefinedSizes;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;

  const ProductSizeSelector({
    super.key,
    required this.availableSizes,
    required this.predefinedSizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: predefinedSizes.map((size) {
            final isSizeAvailable = availableSizes.contains(size);

            return GestureDetector(
              onTap: () {
                if (isSizeAvailable) {
                  onSizeSelected(size);
                } else {
                  CustomAlert.show(
                    context,
                    message: "$size not available",
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 5),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: isSizeAvailable
                      ? (selectedSize == size
                      ? color.tertiary
                      : color.background.withValues(alpha: 0.9))
                      : color.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: color.onSurface,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  size,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selectedSize == size
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: selectedSize == size
                        ? color.onPrimary
                        : color.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
