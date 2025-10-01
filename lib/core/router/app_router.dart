import 'package:dripzy/features/auth/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/get_started_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../routes/routes.dart';

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
  ],
  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
);
