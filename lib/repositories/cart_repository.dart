import 'package:dripzy/core/utils/auth_storage.dart';
import 'package:dripzy/core/utils/result.dart';
import 'package:dripzy/models/cart_model.dart';
import 'package:dripzy/services/cart_service.dart';

class CartRepository {
  final _cartService = CartService();

  Future<Result<Cart>> getCart() async {
    final accessToken = await AuthStorage.getAccessToken();
    if (accessToken == null) {
      return Result.failure('Access token not found');
    }
    try {
      final result = await _cartService.getCart(accessToken: accessToken);
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
        accessToken: accessToken,
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
    final accessToken = await AuthStorage.getAccessToken();
    if (accessToken == null) {
      return Result.failure('Access token not found');
    }

    try {
      final result = await _cartService.addItemToCart(
        accessToken: accessToken,
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
    final accessToken = await AuthStorage.getAccessToken();
    if (accessToken == null) {
      return Result.failure('Access token not found');
    }

    try {
      final success = await _cartService.updateCartItem(
        accessToken: accessToken,
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
    final accessToken = await AuthStorage.getAccessToken();
    if (accessToken == null) {
      return Result.failure('Access token not found');
    }

    try {
      final success = await _cartService.removeItemFromCart(
        accessToken: accessToken,
        productId: productId,
        size: size,
      );
      return Result.success(success);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
