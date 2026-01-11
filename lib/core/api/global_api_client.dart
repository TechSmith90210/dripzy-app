import 'package:dio/dio.dart';

import 'api_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  String? _accessToken;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('TOKEN = $_accessToken');
          print('HEADERS BEFORE = ${options.headers}');
          if (_accessToken != null) {
            options.headers['access-token'] = _accessToken;
          }
          print('HEADERS AFTER = ${options.headers}');
          handler.next(options);
        },

      ),
    );
  }

  void setAccessToken(String token) {
    _accessToken = token;
  }

  void clearAccessToken() {
    _accessToken = null;
  }
}
