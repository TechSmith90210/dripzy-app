import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProductAppBar extends StatelessWidget {
  final VoidCallback onBack;
  const ProductAppBar({super.key, required this.onBack});

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
        onTap: () => context.pop(),
        child: Icon(IconsaxPlusBroken.arrow_left_1),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(IconsaxPlusBroken.heart),
        ),
      ],
    );
  }
}
