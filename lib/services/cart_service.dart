import 'package:dio/dio.dart';
import 'package:dripzy/core/api/api_constants.dart';
import 'package:dripzy/models/cart_model.dart';
import 'package:flutter/cupertino.dart';

class CartService {
  final Dio _dio = Dio();

  Map<String, dynamic> _headers({required String accessToken}) {
    return {'access-token': accessToken};
  }

  Future<Cart> getCart({required String accessToken}) async {
    try {
      final response = await _dio.get(
        ApiConstants.baseUrl + ApiConstants.getCart,
        options: Options(headers: _headers(accessToken: accessToken)),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Cart.fromJson(data['cart']);
      }
      throw Exception(response.data['message']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message']);
    }
  }

  // get cart item quantity
  Future<int> getCartItem({
    required String accessToken,
    required String productId,
    required String size,
  }) async {
    if (size.isEmpty || productId.isEmpty) {
      throw Exception('Please select size and provide productId');
    }
    try {
      final response = await _dio.get(
        ApiConstants.baseUrl + ApiConstants.getCartItem,
        options: Options(headers: _headers(accessToken: accessToken)),
        queryParameters: {'productId': productId, 'size': size},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null &&
            data['success'] == true &&
            data['quantity'] != null) {
          return data['quantity'] as int;
        }
      }
      throw Exception(response.data['message']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message']);
    }
  }

  //add item to cart
  Future<void> addItemToCart({
    required String accessToken,
    required String productId,
    required String size,
  }) async {
    if (size.isEmpty || productId.isEmpty) {
      throw Exception('Please select size and provide productId');
    }

    try {
      final response = await _dio.post(
        ApiConstants.baseUrl + ApiConstants.addCartItem,
        options: Options(headers: _headers(accessToken: accessToken)),
        data: {'productId': productId, 'size': size},
      );
      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data != null && data['success'] == true) {
          return;
        }
      }
      throw Exception(data['message']);
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'];

      if (errorMessage != null && errorMessage.isNotEmpty) {
        // Throw the specific message from the server response data (e.g., 'Item already in cart')
        throw Exception(errorMessage);
      }
      final dioMessage = e.message;
      throw Exception(dioMessage ?? 'An unknown network error occurred.');
    }
  }

  Future<bool> updateCartItem({
    required String accessToken,
    required String productId,
    required String size,
    required int quantity,
  }) async {
    if (size.isEmpty || productId.isEmpty) {
      throw Exception('Please select size and provide productId');
    }

    try {
      final response = await _dio.patch(
        ApiConstants.baseUrl + ApiConstants.updateCartItem,
        options: Options(headers: _headers(accessToken: accessToken)),
        data: {'productId': productId, 'size': size, 'quantity': quantity},
      );

      final data = response.data;
      print("updateItem response: $data");
      if (response.statusCode == 200 &&
          data != null &&
          data['success'] == true) {
        return true; // indicate success
      } else {
        final message =
            data != null && data['message'] != null
                ? data['message']
                : 'Unknown error updating cart item';
        throw Exception(message);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'];
      if (errorMessage != null && errorMessage.isNotEmpty) {
        throw Exception(errorMessage);
      }
      throw Exception(e.message ?? 'An unknown network error occurred.');
    }
  }
}
