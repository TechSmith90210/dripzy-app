import 'package:dripzy/pages/auth/register_screen.dart';
import 'package:dripzy/pages/product/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/auth/get_started_screen.dart';
import '../../pages/auth/login_screen.dart';
import '../../pages/home/home_screen.dart';
import '../../pages/splash/splash_screen.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: AppRoutes.splash,
  // refreshListenable: FirebaseAuthNotifier(),
  routes: [
    GoRoute(
      name: 'splash',
      path: AppRoutes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      name: 'home',
      path: AppRoutes.home,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      name: 'login',
      path: AppRoutes.login,
      builder:
          (context, state) => LoginScreen(
            onBack: () {
              bool canPopBack = GoRouter.of(context).canPop();
              if (!canPopBack) {
                context.goNamed(AppRoutes.getStartedName);
              } else {
                context.pop();
              }
            },
          ),
    ),
    GoRoute(
      name: 'getStarted',
      path: AppRoutes.getStarted,
      builder: (context, state) => GetStartedScreen(),
    ),
    // GoRoute(
    //   name: AppRoutes.verifyOTPName,
    //   path: AppRoutes.verifyOTP,
    //   builder: (context, state) => VerifyOtpScreen(
    //       onBack: () {
    //         bool canPopBack = GoRouter.of(context).canPop();
    //         if (!canPopBack) {
    //           context.goNamed(AppRoutes.getStartedName);
    //         } else {
    //           context.pop();
    //         }
    //       },
    //       phoneNumber: state.extra as String),
    // )
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.registerName,
      builder:
          (context, state) => RegisterScreen(
            onBack: () {
              bool canPopBack = GoRouter.of(context).canPop();
              if (!canPopBack) {
                context.goNamed(AppRoutes.getStartedName);
              } else {
                context.pop();
              }
            },
          ),
    ),

    GoRoute(path: AppRoutes.productPage, name: AppRoutes.productPageName,
      builder: (context, state) {
      final extra = state.extra;
      final productId = extra as String;
        return ProductScreen(productId: productId);
      },

    )
  ],
  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
);
