import 'package:dripzy/blocs/home/home_bloc.dart';
import 'package:dripzy/blocs/product/product_bloc.dart';
import 'package:dripzy/blocs/wishlist/wishlist_bloc.dart';
import 'package:dripzy/core/router/app_router.dart';
import 'package:dripzy/core/theme/app_theme.dart';
import 'package:dripzy/blocs/auth/auth_bloc.dart';
import 'package:dripzy/providers/auth_provider.dart';
import 'package:dripzy/repositories/auth_repository.dart';
import 'package:dripzy/repositories/cart_repository.dart';
import 'package:dripzy/repositories/product_repository.dart';
import 'package:dripzy/repositories/wishlist_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'blocs/cart/cart_bloc.dart';
import 'blocs/splash/splash_cubit.dart';

class DripzyApp extends StatelessWidget {
  const DripzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SplashCubit>(
            create: (context) => SplashCubit()..appStart(),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(repository: AuthRepository()),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(repository: ProductRepository()),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(repository: ProductRepository()),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(repository: CartRepository()),
          ),
          BlocProvider<WishlistBloc>(
            create: (context) => WishlistBloc(repository: WishlistRepository()),
          ),
        ],
        child: Builder(
          builder: (context) {
            return ToastificationWrapper(
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: appRouter,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: ThemeMode.system,
              ),
            );
          },
        ),
      ),
    );
  }
}
