import 'package:dripzy/blocs/cart/cart_bloc.dart';
import 'package:dripzy/blocs/cart/cart_event.dart';
import 'package:dripzy/blocs/wishlist/wishlist_bloc.dart';
import 'package:dripzy/blocs/wishlist/wishlist_event.dart';
import 'package:dripzy/blocs/wishlist/wishlist_state.dart';
import 'package:dripzy/core/router/routes.dart';
import 'package:dripzy/screens/wishlist/wishlist_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
        titleTextStyle: TextStyle(
          color: color.primary,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(IconsaxPlusBroken.arrow_left_1),
        ),
        actions: [],
        centerTitle: true,
        backgroundColor: color.background,
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state.products.isEmpty) {
            return Center(
              child: Text(
                "No Items Wishlisted yet",
                style: TextStyle(color: color.primary),
              ),
            );
          }
          final wishlistItems = state.products;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: GridView.builder(
                itemCount: wishlistItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final item = wishlistItems[index];

                  return WishlistProductCard(
                    productName: item.product.name,
                    price: item.product.price,
                    imageUrl: item.product.images[0],
                    onTapHeart: () {
                      context.read<WishlistBloc>().add(
                        WishlistItemToggled(productId: item.product.id),
                      );
                    },
                    onTapCart: () {
                      // navigate to product page
                      context.push(
                        AppRoutes.productPage,
                        extra: item.product.id,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
