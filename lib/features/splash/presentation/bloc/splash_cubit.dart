import 'package:dripzy/features/splash/presentation/bloc/splash_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  Future<void> appStart() async {
    print("SplashCubit: Starting app...");

    final user = FirebaseAuth.instance.currentUser;

    await Future.delayed(Duration(seconds: 2));

    if (user != null) {
      print("SplashCubit: User found -> Authenticated");
      emit(Authenticated());
    } else {
      print("SplashCubit: User not found -> UnAuthenticated");
      emit(UnAuthenticated());
    }
  }
}
