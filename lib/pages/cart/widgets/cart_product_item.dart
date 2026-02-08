import 'package:dripzy/pages/cart/widgets/quantity_row.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
class CartProductItem extends StatelessWidget {
  final String name;
  final String size;
  final double price;
  final int quantity;
  final String imageUrl;
  final VoidCallback onTapPlus;
  final VoidCallback onTapMinus;
  final VoidCallback onTapDelete;

  const CartProductItem({super.key, required this.name, required this.size, required this.price, required this.quantity, required this.imageUrl, required this.onTapPlus, required this.onTapMinus, required this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      margin: EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product image
          Container(
            height: 150,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: color.primary, width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),

          const SizedBox(width: 10),

          // Rest of content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 30, // this is now your single source of truth
              children: [
                // Title + delete
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4, // spacing inside inner column
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: color.primary,
                            ),
                          ),
                          Text(
                            "Size: $size",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: color.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onTapDelete,
                      child: Icon(
                        IconsaxPlusBroken.trash,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                // Price row
                Row(
                  children: [
                    Text(
                      "₹${price.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: color.primary,
                      ),
                    ),
                    const Spacer(),
                    QuantitySelector(
                      quantity: quantity,
                      onTapPlus: onTapPlus,
                      onTapMinus: onTapMinus,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
