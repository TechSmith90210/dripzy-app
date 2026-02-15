import 'package:dripzy/models/user/user_model.dart';
import 'package:dripzy/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  //register user
  Future<({String? token, User? user})> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final result = await _authService.registerUser(
      email: email,
      password: password,
      name: name,
    );
    return result;
  }

  //login user
  Future<({String? token, User? user})> loginUser({
    required String email,
    required String password,
  }) async {
    final result = _authService.loginUser(email: email, password: password);
    return result;
  }

  //get user data
  Future<({ User? user})> getUserData({
    required String accessToken,
  }) async {
    final result = await _authService.getUserData(accessToken: accessToken);
    return result;
  }
}
