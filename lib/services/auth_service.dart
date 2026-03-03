import 'package:dio/dio.dart';
import 'package:dripzy/models/user/user_model.dart';

import '../core/api/api_constants.dart';

class AuthService {
  final Dio dio = Dio();

  Future<({String? token, User? user})> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.baseUrl + ApiConstants.authRegister,
        data: {"name": name, "email": email, "password": password},
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;
      final user = data['user'] != null ? User.fromJson(data['user']) : null;

      return (token: token, user: user);
    } on DioException catch (e) {
      String errorMessage = 'Network error';
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        errorMessage =
            (e.response!.data as Map<String, dynamic>)['message'] ??
            'Something went wrong';
      }
      throw Exception(errorMessage);
    }
  }

  Future<({String? token, User? user})> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.baseUrl + ApiConstants.authLogin,
        data: {"email": email, "password": password},
      );

      final data = response.data as Map<String, dynamic>;
      return (
      token: data['token'] as String?,
      user: data['user'] != null ? User.fromJson(data['user']) : null,
      );
    } on DioException catch (e) {
      // 1. Check if the backend sent a specific error message (e.g., "Invalid Password")
      final dynamic backendMessage = e.response?.data is Map
          ? e.response?.data['message']
          : null;

      // 2. Determine the best message based on the error type
      String errorMessage;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = "Server is waking up, please try again in a moment.";
          break;
        case DioExceptionType.badResponse:
          errorMessage = backendMessage ?? "Invalid credentials (Error ${e.response?.statusCode})";
          break;
        case DioExceptionType.connectionError:
          errorMessage = "No internet connection detected.";
          break;
        default:
          errorMessage = backendMessage ?? "Connection failed. Please try again.";
      }

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("An unexpected error occurred.");
    }
  }

  //get user data from backend
  Future<({User? user})> getUserData({required String accessToken}) async {
    try {
      final response = await dio.get(
        ApiConstants.baseUrl + ApiConstants.getUserData,
        options: Options(headers: {'access-token': accessToken}),
      );

      if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      }

      final data = response.data as Map<String, dynamic>;
      // final token = data['token'] as String?;
      final user = data['user'] != null ? User.fromJson(data['user']) : null;

      return (user: user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return (user: null); // Signal invalid token
      }
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
}
