import 'package:dripzy/core/api/global_api_client.dart';
import 'package:dripzy/core/router/app_router.dart';
import 'package:dripzy/core/router/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepo;

  AuthBloc({required AuthRepository repository})
    : _authRepo = repository,
      super(AuthInitial()) {
    // Event handlers at the top
    on<RegisterRequested>(_handleRegister);
    on<LoginRequested>(_handleLogin);
    on<UserDataRequested>(_handleGetUserData);
  }

  // ---------------- Private Methods ----------------

  Future<void> _handleRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepo.registerUser(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access-token', response.token!);

      final cx = navigatorKey.currentContext!;
      cx.read<AuthProvider>().setUserData(response.user!);

      //setting the access token for global api client
      ApiClient().setAccessToken(response.token!);
      emit(AuthSuccess(message: "User registered successfully"));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _handleLogin(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepo.loginUser(
        email: event.email,
        password: event.password,
      );

      if (response.user == null) {
        emit(AuthFailure(message: "User does not exist"));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access-token', response.token!);

      final cx = navigatorKey.currentContext!;
      cx.read<AuthProvider>().setUserData(response.user!);

      //setting the access token for global api client
      ApiClient().setAccessToken(response.token!);
      emit(AuthSuccess(message: "User logged in successfully"));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _handleGetUserData(
    UserDataRequested event,
    Emitter<AuthState> emit,
  ) async {
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

      cx.read<AuthProvider>().setUserData(user);
      ApiClient().setAccessToken(event.authToken);
      emit(AuthSuccess(message: "Got user data successfully"));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
