import 'package:dripzy/core/utils/auth_storage.dart';
import 'package:dripzy/core/utils/result.dart';
import 'package:dripzy/models/cart_model.dart';
import 'package:dripzy/services/cart_service.dart';

class CartRepository {
  final _cartService = CartService();

  Future<Result<Cart>> getCart() async {
    try {
      final result = await _cartService.getCart();
      return Result.success(result);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<int>> getCartItem({
    required String productId,
    required String size,
  }) async {
    final accessToken = await AuthStorage.getAccessToken();
    if (accessToken == null) {
      return Result.failure('Access token not found');
    }
    try {
      final result = await _cartService.getCartItem(
        productId: productId,
        size: size,
      );
      return Result.success(result);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> addItemToCart({
    required String productId,
    required String size,
  }) async {
    try {
      final result = await _cartService.addItemToCart(
        productId: productId,
        size: size,
      );
      return Result.success(result);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<bool>> updateCartItem({
    required String productId,
    required String size,
    required int quantity,
  }) async {
    try {
      final success = await _cartService.updateCartItem(
        productId: productId,
        size: size,
        quantity: quantity,
      );
      return Result.success(success); // success is a bool from the service
    } catch (e) {
      print("errrror ${e.toString()}");
      return Result.failure(e.toString());
    }
  }

  Future<Result<bool>> removeItemFromCart({
    required String productId,
    required String size,
  }) async {
    try {
      final success = await _cartService.removeItemFromCart(
        productId: productId,
        size: size,
      );
      return Result.success(success);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
