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
            _row("Subtotal", subTotalPrice),
            _row("Delivery", deliveryCharges),

            const SizedBox(height: 12),

            _totalRow("Total", total),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(
          "₹${value.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
