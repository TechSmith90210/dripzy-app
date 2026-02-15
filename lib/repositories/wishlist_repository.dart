import 'package:dripzy/core/utils/result.dart';
import 'package:dripzy/models/wishlist/wishlist_item_model.dart';
import 'package:dripzy/models/wishlist/wishlist_model.dart';
import 'package:dripzy/services/wishlist_service.dart';

class WishlistRepository {
  final WishlistService _wishlistService = WishlistService();

  Future<Result<Wishlist>> getWishlist() async {
    try {
      final wishlist = await _wishlistService.getWishList();
      if (wishlist != null) {
        return Result.success(wishlist);
      } else {
        return Result.failure("Could not get wishlist");
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<WishlistItem>> addToWishlist(String productId) async {
    try {
      final result = await _wishlistService.addToWishlist(productId: productId);
      return Result.success(result);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<bool>> removeFromWishlist(String productId) async {
    try {
      final removed = await _wishlistService.removeFromWishlist(
        productId: productId,
      );

      if (!removed) {
        return Result.failure("Could not remove item from wishlist.");
      }

      return Result.success(true);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
