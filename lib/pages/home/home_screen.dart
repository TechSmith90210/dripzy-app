import 'package:dripzy/blocs/home/home_event.dart';
import 'package:dripzy/pages/home/widgets/productCard.dart';
import 'package:dripzy/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color.background,
        title: Text(
          'DRIPZY',
          style: TextStyle(
            color: color.primary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(IconsaxPlusBroken.menu_1),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(IconsaxPlusBold.shopping_bag),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(IconsaxPlusBold.profile_circle),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //header text
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.4,
              child: Text(
                "Step Into the New Season",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                  height: 0.9,
                ),
              ),
            ),

            //feed of products
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is HomeError) {
                    CustomAlert.show(context, message: state.error);
                  }
                },
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeLoaded) {
                    return MasonryGridView.count(
                      itemCount: state.products.length,
                      crossAxisCount: 2,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(product: product);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
