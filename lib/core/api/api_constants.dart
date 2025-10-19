//api url

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';

  //auth routes
  static const String authRegister = "/auth/register";
  static const String authLogin = "/auth/login";
  static const String getUserData = "/auth/me";

  //product routes
  static const String getAllProducts = "/products/list";
  static String getProductById(String id) => "/products/$id";
}