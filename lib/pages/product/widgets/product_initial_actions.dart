import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/cart/cart_event.dart';
import '../../../widgets/custom_alert.dart';
import '../../../widgets/custom_button_1.dart';
import '../../../widgets/custom_circle_button.dart';

class ProductInitialActions extends StatelessWidget {
  final String productId;
  final String? selectedSize;

  const ProductInitialActions({
    super.key,
    required this.productId,
    required this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: CustomButton1(
            bgColor: color.onPrimary,
            text: "Buy Now",
            onTap: () {
              if (selectedSize == null || selectedSize!.isEmpty) {
                CustomAlert.show(
                  context,
                  message: "Please select a size first.",
                );
                return;
              }

              // Future: BuyNow flow
              // context.read<CartBloc>().add(
              //   BuyNow(productId: productId, size: selectedSize!),
              // );
            },
          ),
        ),

        Expanded(
          flex: 1,
          child: CustomCircleButton(
            size: 40,
            bgColor: color.tertiary,
            icon: IconsaxPlusBroken.add,
            onTap: () {
              if (selectedSize == null || selectedSize!.isEmpty) {
                CustomAlert.show(
                  context,
                  message: "Please select a size first.",
                );
                return;
              }

              context.read<CartBloc>().add(
                CartItemAdded(
                  productId: productId,
                  size: selectedSize!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
