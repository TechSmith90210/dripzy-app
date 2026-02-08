import 'package:dripzy/blocs/cart/cart_event.dart';
import 'package:dripzy/blocs/cart/cart_state.dart';
import 'package:dripzy/pages/cart/dialogs/cart_removal_dialog.dart';
import 'package:dripzy/pages/cart/widgets/cart_product_item.dart';
import 'package:dripzy/pages/cart/widgets/checkout_bar.dart';
import 'package:dripzy/widgets/custom_alert.dart';
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
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.cart.products.isNotEmpty) {
                return IconButton(
                  onPressed: () {
                    showClearCartDialog(
                      context: context,
                      onConfirm: () {
                        context.pop();
                        context.read<CartBloc>().add(ClearCart());
                      },
                    );
                  },
                  icon: const Icon(IconsaxPlusBroken.bag_cross),
                );
              }

              return const SizedBox(); // no button if cart empty
            },
          ),
        ],

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
                  return CartProductItem(
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

      //persistent bottom sheet with cta including a dropdown showing the included charges
      bottomSheet: SafeArea(
        top: false,
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              final cart = state.cart;
              final noOfItems = cart.products.length;

              final priceBreakDown = state.priceBreakdown;

              if (noOfItems > 0) {
                return CheckoutBar(
                  totalValue: priceBreakDown.totalValue,
                  itemsValue: noOfItems,
                  onCheckout: () {},
                  shippingPrice: priceBreakDown.shippingPrice,
                  subTotalPrice: priceBreakDown.subTotal,
                );
              }
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
