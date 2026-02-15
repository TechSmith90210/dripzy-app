import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_constants.dart';

class ApiClient {
  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;
  String? _accessToken;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        // Use your base URL from constants
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    // Logging only in Debug Mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          compact: true,
        ),
      );
    }

    // Auth Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null) {
            // Adjust key 'access-token' or 'Authorization' based on your backend
            options.headers['access-token'] = _accessToken;
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // You can handle global errors here (like 401 logging out the user)
          if (e.response?.statusCode == 401) {
            debugPrint('Unauthorized: Token might be expired.');
          }
          return handler.next(e);
        },
      ),
    );
  }

  // --- Token Management ---
  void setAccessToken(String token) => _accessToken = token;
  void clearAccessToken() => _accessToken = null;

  // --- HTTP Methods ---

  /// GET: Fetch data from the server
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  /// POST: Create new data on the server
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  /// PUT: Update/Replace an entire resource
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH: Update specific fields of a resource
  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE: Remove data from the server
  Future<Response> delete(String path, {dynamic data}) async {
    try {
      return await _dio.delete(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
}