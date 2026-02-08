import 'package:dripzy/pages/cart/widgets/coupon_modal.dart';
import 'package:flutter/material.dart';

class CouponStrip extends StatelessWidget {
  const CouponStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => CouponModal(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.onPrimary.withAlpha(20),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          border: Border.all(color: color.onSecondary.withAlpha(112)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Apply Coupon",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.keyboard_arrow_up),
          ],
        ),
      ),
    );
  }
}
