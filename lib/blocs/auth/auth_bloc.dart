import 'package:dripzy/core/api/global_api_client.dart';
import 'package:dripzy/core/router/app_router.dart';
import 'package:dripzy/core/router/routes.dart';
import 'package:dripzy/core/utils/auth_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

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
    on<LogoutRequested>(_handleLogout);
    on<GoogleSignInRequested>(_handleGoogleSignIn);
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

  Future<void> _handleLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    ApiClient().clearAccessToken();
    AuthProvider().clearUser();
    AuthStorage.clearAccessToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access-token');

    navigatorKey.currentContext?.goNamed(AppRoutes.getStartedName);
    emit(AuthSuccess(message: "Logged out successfully"));
  }

  Future<void> _handleGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthFailure(message: "Google Sign-in was cancelled"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final fb.AuthCredential credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final fb.UserCredential userCredential =
          await fb.FirebaseAuth.instance.signInWithCredential(credential);

      final String? firebaseIdToken =
          await userCredential.user?.getIdToken();

      if (firebaseIdToken == null) {
        emit(AuthFailure(message: "Could not retrieve Firebase ID Token"));
        return;
      }

      final response = await _authRepo.googleLogin(idToken: firebaseIdToken);

      if (response.user == null || response.token == null) {
        emit(AuthFailure(message: "Authentication with backend failed"));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access-token', response.token!);

      final cx = navigatorKey.currentContext!;
      cx.read<AuthProvider>().setUserData(response.user!);

      ApiClient().setAccessToken(response.token!);
      emit(AuthSuccess(message: "User logged in successfully with Google"));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
