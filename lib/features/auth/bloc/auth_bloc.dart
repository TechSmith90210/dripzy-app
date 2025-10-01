import 'package:dripzy/core/router/app_router.dart';
import 'package:dripzy/core/routes/routes.dart';
import 'package:dripzy/features/auth/bloc/auth_event.dart';
import 'package:dripzy/features/auth/bloc/auth_state.dart';
import 'package:dripzy/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:dripzy/features/splash/presentation/cubit/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/auth_provider.dart';
import '../repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepo = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _authRepo.registerUser(
          email: event.email,
          password: event.password,
          name: event.name,
        );
        //store the access token in sharedPrefs
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access-token', response.token!);

        //set user data in provider
        final cx = navigatorKey.currentContext!;
        cx.read<AuthProvider>().setUserData(response.user!);

        emit(AuthSuccess(message: "User registered successfully"));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _authRepo.loginUser(
          email: event.email,
          password: event.password,
        );

        if(response.user == null){
          emit(AuthFailure(message: "User does not exist"));
          return;
        }

        //store access token in sharedPrefs
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access-token', response.token!);

        //set user data in provider
        final cx = navigatorKey.currentContext!;
        cx.read<AuthProvider>().setUserData(response.user!);

        emit(AuthSuccess(message: "User logged in successfully"));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    on<UserDataRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _authRepo.getUserData(
          accessToken: event.authToken,
        );

        final user = response.user;
        final cx = navigatorKey.currentContext!;

        if (user == null) {
          print('user does not exist, going to get started');
          cx.goNamed(AppRoutes.getStartedName);
          emit(AuthFailure(message: "User does not exist"));
          return;
        }

        //set user data in provider
        cx.read<AuthProvider>().setUserData(user);

        emit(AuthSuccess(message: "Got user data successfully"));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    //we are using email and password style login for now
  }
}
