import 'package:flutter/material.dart';

class PriceBreakDownModal extends StatelessWidget {
  final double subTotalPrice;
  final double deliveryCharges;

  const PriceBreakDownModal({
    super.key,
    required this.subTotalPrice,
    required this.deliveryCharges,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final total = subTotalPrice + deliveryCharges;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row("Subtotal", subTotalPrice, color),
            _row("Delivery", deliveryCharges, color),

            const SizedBox(height: 12),

            _totalRow("Total", total, color),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double value, ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: color.primary)),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double value, ColorScheme color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color.primary,
          ),
        ),
        Text(
          "₹${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color.primary,
          ),
        ),
      ],
    );
  }
}
