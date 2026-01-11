import 'package:dripzy/blocs/cart/cart_event.dart';
import 'package:dripzy/blocs/cart/cart_state.dart';
import 'package:dripzy/widgets/custom_alert.dart';
import 'package:dripzy/widgets/custom_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../blocs/cart/cart_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    //get cart from cartBloc
    context.read<CartBloc>().add(GetUserCart());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        titleTextStyle: TextStyle(
          color: color.primary,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(IconsaxPlusBroken.arrow_left_1),
        ),
        centerTitle: true,
        backgroundColor: color.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartLoaded) {
              final cart = state.cart;

              if (cart.products.isEmpty) {
                return Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color.primary,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: cart.products.length,
                itemBuilder: (context, index) {
                  final product = cart.products[index];
                  return _buildCartProductItem(
                    color: color,
                    name: product.product.name,
                    size: product.size,
                    price: product.product.price,
                    quantity: product.quantity,
                    imageUrl: product.product.images[0],
                    onTapPlus: () {
                      if (product.quantity < product.product.availableStock) {
                        context.read<CartBloc>().add(
                          UpdateCartItemQuantity(
                            productId: product.product.id,
                            size: product.size,
                            quantity: product.quantity + 1,
                          ),
                        );
                      } else {
                        CustomAlert.show(
                          context,
                          message: "No more stock available",
                        );
                      }
                    },
                    onTapMinus: () {
                      context.read<CartBloc>().add(
                        UpdateCartItemQuantity(
                          productId: product.product.id,
                          size: product.size,
                          quantity: product.quantity - 1,
                        ),
                      );
                    },
                    onTapDelete: () {
                      context.read<CartBloc>().add(
                        RemoveCartItem(
                          productId: product.product.id,
                          size: product.size,
                        ),
                      );
                    },
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildCartProductItem({
    required ColorScheme color,
    required String name,
    required String size,
    required double price,
    required int quantity,
    required String imageUrl,
    required VoidCallback onTapPlus,
    required VoidCallback onTapMinus,
    required VoidCallback onTapDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            height: 120,
            width: 100,
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
              spacing: 27,
              children: [
                // Title + delete
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: color.primary,
                            ),
                          ),
                          SizedBox(height: 4),
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

                // Price
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
                    // Quantity
                    _buildQuantityRow(
                      color: color,
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

  Widget _buildQuantityRow({
    required ColorScheme color,
    required int quantity,
    required VoidCallback onTapPlus,
    required VoidCallback onTapMinus,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        // Minus
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

        // Quantity
        Text(
          quantity.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color.primary,
          ),
        ),

        // Plus
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
