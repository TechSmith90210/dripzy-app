import 'package:dripzy/core/router/app_router.dart';
import 'package:dripzy/features/auth/bloc/auth_event.dart';
import 'package:dripzy/features/splash/presentation/cubit/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/bloc/auth_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  Future<void> appStart() async {
    print("SplashCubit: Starting app...");
    emit(DisplaySplash());

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access-token');
    print("access token : $accessToken");
    if (accessToken == null || accessToken.isEmpty) {
      emit(UnAuthenticated());
      print("No access token, Sending to get started screen");
      return;
    }

    print("fetching user data from backend");
    final cx = navigatorKey.currentContext!;
    cx.read<AuthBloc>().add(UserDataRequested(authToken: accessToken));
  }
}
