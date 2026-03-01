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

  //cart routes
  static const String getCart = "/cart/getCart";
  static const String getCartItem = "/cart/getCartItem";
  static const String addCartItem = "/cart/addItem";
  static const String updateCartItem = "/cart/updateItem";
  static const String deleteCartItem = "/cart/removeItem";
  static const String clearCart = "/cart/clearCart";

  //wishlist routes
  static const String getWishlist = "/wishlist/";
  static const String addToWishlist = "/wishlist/";
  static String removeFromWishlist(String productId) => "/wishlist/$productId";

  //address routes
  static const String getAllAddresses = "/address";
  static const String addAddress = "/address";
  static String updateAddress(String id) => "/address/$id";
  static String deleteAddress(String id) => "/address/$id";
  static String setDefaultAddress(String id) => "/address/$id/default";
}
