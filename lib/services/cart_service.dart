import 'package:dio/dio.dart';
import 'package:dripzy/core/api/api_constants.dart';
import 'package:dripzy/core/api/global_api_client.dart';
import 'package:dripzy/models/cart/cart_model.dart';
import 'package:flutter/foundation.dart';

import '../models/cart/cart_response_model.dart';
import '../models/cart/price_breakdown_model.dart';

class CartService {
  final Dio _dio = ApiClient().dio;

  // ---------------- GET CART ----------------
  Future<CartResponse> getCart() async {
    try {
      final response = await _dio.get(ApiConstants.getCart);
      return CartResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return CartResponse(
          cart: Cart.empty(),
          priceBreakdown: PriceBreakdown(
            subTotal: 0,
            isFreeShippingEligible: false,
            shippingPrice: 0,
            totalValue: 0,
          ),
        );
      }
      throw Exception(e.response?.data?['message'] ?? 'Failed to fetch cart');
    }
  }

  // ---------------- GET CART ITEM QUANTITY ----------------
  Future<int> getCartItem({
    required String productId,
    required String size,
  }) async {
    if (size.isEmpty || productId.isEmpty) {
      throw Exception('Please select size and provide productId');
    }

    try {
      final response = await _dio.get(
        ApiConstants.getCartItem,
        queryParameters: {'productId': productId, 'size': size},
      );

      final data = response.data;
      if (data != null && data['success'] == true) {
        return data['quantity'] as int;
      }

      throw Exception(data['message']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch cart item',
      );
    }
  }

  // ---------------- ADD ITEM ----------------
  Future<void> addItemToCart({
    required String productId,
    required String size,
  }) async {
    if (size.isEmpty || productId.isEmpty) {
      throw Exception('Please select size and provide productId');
    }

    try {
      final response = await _dio.post(
        ApiConstants.addCartItem,
        data: {'productId': productId, 'size': size},
      );

      if (response.data?['success'] != true) {
        throw Exception(response.data?['message']);
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to add item to cart',
      );
    }
  }

  // ---------------- UPDATE ITEM ----------------
  Future<bool> updateCartItem({
    required String productId,
    required String size,
    required int quantity,
  }) async {
    if (size.isEmpty || productId.isEmpty) {
      throw Exception('Please select size and provide productId');
    }

    try {
      final response = await _dio.patch(
        ApiConstants.updateCartItem,
        data: {'productId': productId, 'size': size, 'quantity': quantity},
      );

      if (response.data?['success'] == true) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to update cart item',
      );
    }
  }

  // ---------------- REMOVE ITEM ----------------
  Future<bool> removeItemFromCart({
    required String productId,
    required String size,
  }) async {
    if (size.isEmpty || productId.isEmpty) {
      throw Exception('Please select size and provide productId');
    }

    try {
      final response = await _dio.delete(
        ApiConstants.deleteCartItem,
        data: {'productId': productId, 'size': size},
      );

      if (response.data?['success'] == true) {
        return true;
      }

      debugPrint('[CartService] Item removed');
      return false;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to remove item from cart',
      );
    }
  }

  // ------CLEAR CART-------

  Future<bool> clearEntireCart() async {
    try {
      final response = await _dio.delete(ApiConstants.clearCart);
      if (response.data?['success'] == true) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to clear cart');
    }
  }
}
