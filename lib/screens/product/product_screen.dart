import 'package:collection/collection.dart';
import 'package:dripzy/blocs/cart/cart_event.dart';
import 'package:dripzy/blocs/cart/cart_state.dart';
import 'package:dripzy/blocs/product/product_bloc.dart';
import 'package:dripzy/blocs/product/product_event.dart';
import 'package:dripzy/blocs/product/product_state.dart';
import 'package:dripzy/blocs/wishlist/wishlist_bloc.dart';
import 'package:dripzy/blocs/wishlist/wishlist_event.dart';
import 'package:dripzy/blocs/wishlist/wishlist_state.dart';
import 'package:dripzy/models/wishlist/wishlist_model.dart';
import 'package:dripzy/screens/product/widgets/product_app_bar.dart';
import 'package:dripzy/screens/product/widgets/product_image_carousel.dart';
import 'package:dripzy/screens/product/widgets/product_initial_actions.dart';
import 'package:dripzy/screens/product/widgets/product_quantity_controls.dart';
import 'package:dripzy/screens/product/widgets/product_size_selector.dart';
import 'package:dripzy/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../core/utils/debouncer.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  static const List<String> predefinedSizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];
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
                    BlocBuilder<WishlistBloc, WishlistState>(
                      builder: (context,state){
                        final isWishlisted = state.isWishlisted(product.id);
                        return ProductAppBar(
                          isWishlisted: isWishlisted,
                          onBack: () => context.pop(),
                          onHeartClick: () {
                            context.read<WishlistBloc>().add(
                              WishlistItemToggled(productId: widget.productId),
                            );
                          },
                        );
                      },

                    ),

                    //carousel image viewer
                    SliverPadding(
                      padding: const EdgeInsets.all(5),
                      sliver: SliverToBoxAdapter(
                        child: ProductImageCarousel(images: product.images),
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
                    ProductSizeSelector(
                      availableSizes: product.sizes,
                      predefinedSizes: predefinedSizes,
                      selectedSize: selectedSize,
                      onSizeSelected: (size) {
                        setState(() {
                          selectedSize = size;
                        });

                        context.read<CartBloc>().add(
                          GetCartItem(productId: product.id, size: size),
                        );
                      },
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

                      if (quantity > 0) {
                        return ProductQuantityControls(
                          quantity: quantity,
                          onIncrement: () {
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
                          onDecrement: () {
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

                      return ProductInitialActions(
                        productId: product.id,
                        selectedSize: selectedSize,
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
}
