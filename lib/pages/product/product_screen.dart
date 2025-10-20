import 'package:carousel_slider/carousel_slider.dart';
import 'package:dripzy/blocs/product/product_bloc.dart';
import 'package:dripzy/blocs/product/product_event.dart';
import 'package:dripzy/blocs/product/product_state.dart';
import 'package:dripzy/widgets/customCircleButton.dart';
import 'package:dripzy/widgets/custom_alert.dart';
import 'package:dripzy/widgets/custom_button_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<String> predefinedSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  int _currentImageIndex = 0;

  @override
  void initState() {
    context.read<ProductBloc>().add(
      LoadSingleProduct(productId: widget.productId),
    );
    super.initState();
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
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(IconsaxPlusBroken.heart),
                        ),
                      ],
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
                                scrollPhysics: BouncingScrollPhysics()
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

                    SliverToBoxAdapter(child: SizedBox(height: 5,),),

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
                    BlocSelector<ProductBloc, ProductState, String>(
                      selector: (state) {
                        if (state is ProductLoaded)
                          return state.selectedSize ?? '';
                        return '';
                      },
                      builder: (context, state) {
                        return _buildSizesRow(
                          sizes: product.sizes,
                          color: color,
                          onTapSize: (selectedSize) {
                            context.read<ProductBloc>().add(
                              SelectProductSize(size: selectedSize),
                            );
                          },
                          selectedSize: state,
                        );
                      },
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 13)),

                    //description
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: Container(
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
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),

                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: CustomButton1(
                          bgColor: color.onPrimary,
                          text: "Buy Now",
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomCircleButton(
                          size: 40,
                          bgColor: color.tertiary,
                          icon: IconsaxPlusBroken.add,
                          onTap: () {},
                        ),
                      ),
                    ],
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
    required String selectedSize,
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
}
