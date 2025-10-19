import 'package:dripzy/blocs/home/home_bloc.dart';
import 'package:dripzy/core/router/app_router.dart';
import 'package:dripzy/core/theme/app_theme.dart';
import 'package:dripzy/blocs/auth/auth_bloc.dart';
import 'package:dripzy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

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
          BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
          BlocProvider<HomeBloc>(create: (context) => HomeBloc(),)
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
