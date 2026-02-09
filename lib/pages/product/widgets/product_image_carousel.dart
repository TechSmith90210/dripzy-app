import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;

  const ProductImageCarousel({
    super.key,
    required this.images,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.7,
            enableInfiniteScroll: false,
            viewportFraction: 1,
            enlargeCenterPage: false,
            scrollPhysics: const BouncingScrollPhysics(),
            onPageChanged: (index, _) {
              setState(() => _currentIndex = index);
            },
          ),
          items: widget.images.map((image) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: color.onSurface,
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (_, __, ___) {
                    return const Center(child: Text("No Image"));
                  },
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? color.primary
                    : color.primary.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
