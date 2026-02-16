import 'package:dripzy/screens/cart/widgets/price_breakdown_modal.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_button_1.dart';

class CheckoutBar extends StatelessWidget {
  final double totalValue;
  final int itemsValue;
  final VoidCallback onCheckout;
  final double shippingPrice;
  final double subTotalPrice;

  const CheckoutBar({
    super.key,
    required this.totalValue,
    required this.itemsValue,
    required this.onCheckout,
    required this.shippingPrice,
    required this.subTotalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: const Offset(0, -4),
              color: Colors.black.withAlpha(25),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total", style: TextStyle(color: Colors.grey)),
                    Row(
                      children: [
                        Text(
                          "₹$totalValue",
                          style:  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color.primary
                          ),
                        ),
                        SizedBox(width: 7),
                        GestureDetector(
                          onTap: () {
                            //show the price calculation modal sheet
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder:
                                  (_) => PriceBreakDownModal(
                                    subTotalPrice: subTotalPrice,
                                    deliveryCharges: shippingPrice,
                                  ),
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            color: color.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "$itemsValue items",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 12),

            CustomButton1(
              bgColor: color.primary,
              text: "Proceed to checkout",
              onTap: onCheckout,
            ),
          ],
        ),
      ),
    );
  }
}
