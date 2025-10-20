import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dripzy/models/product_model.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _showOverlay = false;
  int _currentImageIndex = 0;
  Timer? _imageTimer;
  final _random = Random();

  @override
  void initState() {
    super.initState();

    if (widget.product.images.length > 1) {
      _scheduleNextImage();
    }
  }

  void _scheduleNextImage() {
    final duration = Duration(seconds: 5 + _random.nextInt(10)); // 3-6 sec
    _imageTimer = Timer(duration, () {
      if (!mounted) return;
      setState(() {
        _currentImageIndex =
            (_currentImageIndex + 1) % widget.product.images.length;
      });
      _scheduleNextImage(); // schedule next with a new random duration
    });
  }

  @override
  void dispose() {
    _imageTimer?.cancel();
    super.dispose();
  }

  void _showOverlayForTap() {
    setState(() => _showOverlay = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showOverlay = false);
    });
  }

  void _showOverlayForLongPress() => setState(() => _showOverlay = true);
  void _hideOverlay() => setState(() => _showOverlay = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showOverlayForTap();
        if (widget.onTap != null) widget.onTap!();
      },
      onLongPressStart: (_) => _showOverlayForLongPress(),
      onLongPressEnd: (_) => _hideOverlay(),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              child: Image.network(
                widget.product.images[_currentImageIndex],
                key: ValueKey<int>(_currentImageIndex),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _showOverlay ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${widget.product.price}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
