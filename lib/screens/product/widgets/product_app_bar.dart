import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProductAppBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onHeartClick;
  final bool isWishlisted;
  const ProductAppBar({
    super.key,
    required this.onBack,
    required this.onHeartClick,
    required this.isWishlisted,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SliverAppBar(
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
        onTap: onBack,
        child: Icon(IconsaxPlusBroken.arrow_left_1),
      ),
      actions: [
        IconButton(
          onPressed: onHeartClick,
          icon: Icon(
            isWishlisted ? IconsaxPlusBold.heart : IconsaxPlusBroken.heart,
            color: isWishlisted ? color.tertiary : color.primary,
          ),
        ),
      ],
    );
  }
}
