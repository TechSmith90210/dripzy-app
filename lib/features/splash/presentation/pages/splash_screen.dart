import 'package:dripzy/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/splash_cubit.dart';
import '../bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashState>(
        listenWhen: (previous, current) =>
            current is Authenticated || current is UnAuthenticated,
        listener: (context, state) {
          if (state is Authenticated) {
            context.go(AppRoutes.home);
          } else if (state is UnAuthenticated) {
            context.go(AppRoutes.getStarted);
          }
        },
        builder: (context, state) {
          if (state is DisplaySplash) {
            return Scaffold(
              body: Center(
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset('assets/dripzy_app_logo.png')),
              ),
            );
          }
          return const Scaffold(body: CircularProgressIndicator());
        });
  }
}
