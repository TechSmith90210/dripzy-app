import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:dripzy/blocs/cart/cart_event.dart';
import 'package:dripzy/blocs/cart/cart_state.dart';
import 'package:dripzy/blocs/product/product_bloc.dart';
import 'package:dripzy/blocs/product/product_event.dart';
import 'package:dripzy/blocs/product/product_state.dart';
import 'package:dripzy/widgets/custom_circle_button.dart';
import 'package:dripzy/widgets/custom_alert.dart';
import 'package:dripzy/widgets/custom_button_1.dart';
import 'package:dripzy/widgets/custom_icon_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../core/utils/debouncer.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<String> predefinedSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  int _currentImageIndex = 0;
  String? selectedSize;

  late final Debouncer _quantityDebouncer;
  late final CartBloc _cartBloc;

  @override
  void initState() {
    context.read<ProductBloc>().add(
      LoadSingleProduct(productId: widget.productId),
    );
    _quantityDebouncer = Debouncer(milliseconds: 50);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _cartBloc = context.read<CartBloc>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _cartBloc.add(ClearCartItemState());
    _quantityDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            CustomAlert.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is ProductInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final product = state.product;
            print(product.images);
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Text("Details"),
                      titleTextStyle: TextStyle(
                        color: color.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      centerTitle: true,
                      floating: true,
                      backgroundColor: color.background,
                      leading: GestureDetector(
                        onTap: () => context.pop(),
                        child: Icon(IconsaxPlusBroken.arrow_left_1),
                      ),
                      // actions: [
                      //   IconButton(
                      //     onPressed: () {},
                      //     icon: Icon(IconsaxPlusBroken.heart),
                      //   ),
                      // ],
                    ),

                    //carousel image viewer
                    SliverPadding(
                      padding: const EdgeInsets.all(5.0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                enableInfiniteScroll: false,
                                viewportFraction: 1,
                                enlargeCenterPage: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                                scrollPhysics: BouncingScrollPhysics(),
                              ),
                              items:
                                  product.images
                                      .map(
                                        (e) => Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5.0,
                                            ),
                                            border: Border.all(
                                              color: color.onSurface,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              5.0,
                                            ),
                                            child: Image.network(
                                              e,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return const Center(
                                                  child: Text("No Image"),
                                                );
                                              },
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  product.images.asMap().entries.map((entry) {
                                    return Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            _currentImageIndex == entry.key
                                                ? color.primary
                                                : color.primary.withOpacity(
                                                  0.3,
                                                ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 5)),

                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: color.primary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹${product.price.toInt().toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: color.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 10)),
                    //sizes
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          "Sizes",
                          style: TextStyle(color: color.primary, fontSize: 12),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 8)),
                    _buildSizesRow(
                      sizes: product.sizes,
                      color: color,
                      onTapSize: (size) {
                        setState(() {
                          selectedSize = size;
                        });
                        context.read<CartBloc>().add(
                          GetCartItem(productId: product.id, size: size),
                        );
                      },
                      selectedSize: selectedSize,
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 13)),

                    //description
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                color: color.primary,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              product.description,
                              style: TextStyle(
                                color: color.primary.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w100,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),

                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  child: BlocConsumer<CartBloc, CartState>(
                    listener: (context, state) {
                      if (state is CartItemQuantityState &&
                          state.message.isNotEmpty) {
                        // Show alert/toast when item is added
                        CustomAlert.show(context, message: state.message);
                      }
                      if (state is CartError) {
                        CustomAlert.show(context, message: state.message);
                      }
                    },
                    builder: (context, state) {
                      int quantity = 0;

                      if (selectedSize == null) {
                        quantity = 0;
                      } else if (state is CartItemQuantityState) {
                        quantity = state.sizeQuantityMap[selectedSize] ?? 0;
                      } else if (state is CartLoaded) {
                        final item = state.cart.products.firstWhereOrNull(
                              (p) =>
                          p.product.id == widget.productId &&
                              p.size == selectedSize,
                        );
                        quantity = item?.quantity ?? 0;
                      }

                      print("quantity for size $selectedSize → $quantity");



                      print("quantity for size $selectedSize → $quantity");

                      if (quantity > 0) {
                        return _buildQuantityButton(
                          color: color,
                          selectedSize: selectedSize!,
                          quantity: quantity,
                          onTapPlus: () {
                            _quantityDebouncer.run(
                              () => context.read<CartBloc>().add(
                                UpdateCartItemQuantity(
                                  productId: product.id,
                                  size: selectedSize!,
                                  quantity: quantity + 1,
                                ),
                              ),
                            );
                          },
                          onTapMinus: () {
                            if (quantity > 0) {
                              _quantityDebouncer.run(
                                () => context.read<CartBloc>().add(
                                  UpdateCartItemQuantity(
                                    productId: product.id,
                                    size: selectedSize!,
                                    quantity: quantity - 1,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }

                      return _buildInitialButtons(
                        color: color,
                        productId: product.id,
                        size: selectedSize,
                        price: product.price,
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSizesRow({
    required List<String> sizes,
    required ColorScheme color,
    required Function(String) onTapSize,
    required String? selectedSize,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverToBoxAdapter(
        child: Row(
          children:
              predefinedSizes.map((e) {
                final isSizeAvailable = sizes.contains(e);
                return GestureDetector(
                  onTap: () {
                    isSizeAvailable
                        ? onTapSize(e)
                        : CustomAlert.show(
                          context,
                          message: "$e not available",
                        );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color:
                          isSizeAvailable
                              ? (selectedSize == e
                                  ? color.tertiary
                                  : color.background.withValues(alpha: 0.9))
                              : color.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: color.onSurface, width: 0.5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    child: Text(
                      e.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            selectedSize == e
                                ? FontWeight.w700
                                : FontWeight.w400,
                        color:
                            selectedSize == e ? color.onPrimary : color.primary,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildInitialButtons({
    required ColorScheme color,
    required String? productId,
    required String? size,
    required double price,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: CustomButton1(
            bgColor: color.onPrimary,
            text: "Buy Now",
            onTap: () {
              // Check size and dispatch BuyNow event
              if (selectedSize == null || size!.isEmpty) {
                CustomAlert.show(
                  context,
                  message: "Please select a size first.",
                );
                return;
              }
              // context.read<CartBloc>().add(
              //   BuyNow(productId: productId!, size: selectedSize!),
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
              // Check size and dispatch AddItemToCart event
              if (size == null || size.isEmpty) {
                CustomAlert.show(
                  context,
                  message: "Please select a size first.",
                );
                return;
              }
              context.read<CartBloc>().add(
                CartItemAdded(productId: productId!, size: size),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required ColorScheme color,
    required String selectedSize,
    required int quantity,
    required VoidCallback onTapPlus,
    required VoidCallback onTapMinus,
  }) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Minus Button
        Expanded(
          flex: 2,
          child: CustomIconButton2(
            icon: IconsaxPlusBroken.minus,
            onPressed: onTapMinus,
            bgColor: color.surface,
            fgColor: color.primary,
          ),
        ),

        Expanded(
          flex: 3,
          child: Container(
            // Adjusted padding for a taller, more defined look
            padding: const EdgeInsets.symmetric(vertical: 6),

            decoration: BoxDecoration(
              // Use a darker background for better visibility, e.g., tertiary or a soft contrast
              color: color.onPrimary.withValues(
                alpha: 0.7,
              ), // Soft, visible background
              borderRadius: BorderRadius.circular(16), // Increased roundness
              border: Border.all(
                color: color.primary.withOpacity(
                  0.3,
                ), // Light border for definition
                width: 1,
              ),
            ),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 18,
                // Use a bold weight to make the number pop
                fontWeight: FontWeight.w700,
                color: color.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Plus Button
        Expanded(
          flex: 2,
          child: CustomIconButton2(
            icon: IconsaxPlusBroken.add,
            onPressed: onTapPlus,
            // Use an accent color for the main action button (Add/Plus)
            bgColor: color.tertiary,
            fgColor: color.primary,
          ),
        ),
      ],
    );
  }
}
