import 'package:dripzy/core/auth/firebase_auth_notifier.dart';
import 'package:dripzy/features/auth/get_started_screen.dart';
import 'package:dripzy/features/splash/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/home/home_screen.dart';
import '../routes/routes.dart';

final appRouter = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: FirebaseAuthNotifier(),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.getStarted,
        builder: (context, state) => GetStartedScreen(),
      )
    ]);
