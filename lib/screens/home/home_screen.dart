import 'package:dripzy/blocs/cart/cart_bloc.dart';
import 'package:dripzy/blocs/cart/cart_event.dart';
import 'package:dripzy/blocs/cart/cart_state.dart';
import 'package:dripzy/blocs/home/home_event.dart';
import 'package:dripzy/core/router/routes.dart';
import 'package:dripzy/screens/home/widgets/product_card.dart';
import 'package:dripzy/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeBloc>().add(LoadProducts());
    context.read<CartBloc>().add(GetUserCart());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            CustomAlert.show(context, message: state.error);
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildShimmerPlaceholder();
          } else if (state is HomeLoaded) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  title: const Text('DRIPZY'),
                  titleTextStyle: TextStyle(
                    color: color.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: 4,
                  ),
                  backgroundColor: color.surface,
                  scrolledUnderElevation: 0,
                  floating: true,
                  snap: true,
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(IconsaxPlusBroken.menu_1, size: 22),
                  ),
                  actions: [
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        int itemCount = 0;

                        if (state is CartLoaded) {
                          itemCount = state.cart.products.length;
                        }

                        final cartIcon = IconButton(
                          onPressed: () {
                            context.pushNamed(AppRoutes.cartName);
                          },
                          icon: const Icon(IconsaxPlusBroken.shopping_bag, size: 22),
                        );

                        if (itemCount > 0) {
                          return Badge(
                            label: Text(
                              itemCount.toString(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: color.primary,
                            textColor: color.surface,
                            child: cartIcon,
                          );
                        }

                        return cartIcon;
                      },
                    ),

                    IconButton(
                      onPressed: () {
                        context.push(AppRoutes.profile);
                      },
                      icon: const Icon(IconsaxPlusBroken.profile_circle, size: 22),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                //header text
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Text(
                      "Step Into the New Season",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                        height: 0.9,
                        color: color.primary,
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                  sliver: SliverMasonryGrid.count(
                    childCount: state.products.length,
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          context.push(
                            AppRoutes.productPage,
                            extra: product.id,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //shimmer header text
          Padding(
            padding: EdgeInsets.all(10),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width / 1.4,
                color: Colors.white,
              ),
            ),
          ),

          // Grid shimmer placeholders
          MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 3,
            shrinkWrap: true,
            itemCount: 8, // mock items
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 200 + (index % 3) * 40, // random height variation
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
