import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              context.go(AppRoutes.getStarted);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go(AppRoutes.home);
            } else if (state is AuthFailure) {
              context.go(AppRoutes.getStarted);
            }
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: Image.asset('assets/dripzy_app_logo.png'),
          ),
        ),
      ),
    );
  }
}
