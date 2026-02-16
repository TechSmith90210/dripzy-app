import 'package:flutter/material.dart';

class CouponModal extends StatelessWidget {
  const CouponModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Apply coupon",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 15),

            // Input
            TextField(
              decoration: InputDecoration(
                hintText: "Enter code",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
            ),

            const SizedBox(height: 16),

            _couponRow(
              context,
              code: "SAVE20",
              desc: "20% off up to ₹200",
              onTap: () {},
            ),
            _couponRow(
              context,
              code: "FREESHIP",
              desc: "Free delivery",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _couponRow(
    BuildContext context, {
    required String code,
    required String desc,
    required VoidCallback onTap,
  }) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                code,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          OutlinedButton(
            onPressed: onTap,
            child: Text(
              "Apply",
              style: TextStyle(
                fontSize: 12,
                color: color.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
