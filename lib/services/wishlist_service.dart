import 'package:dio/dio.dart';
import 'package:dripzy/core/api/api_constants.dart';
import 'package:dripzy/core/api/global_api_client.dart';
import 'package:dripzy/models/wishlist/wishlist_item_model.dart';
import 'package:dripzy/models/wishlist/wishlist_model.dart';

class WishlistService {
  final ApiClient client = ApiClient();

  //get wishlist
  Future<Wishlist> getWishList() async {
    try {
      final response = await client.get(ApiConstants.getWishlist);
      if (response.statusCode == 200) {
        final data = response.data;
        return Wishlist.fromJson(data);
      }
      throw Exception(
        "Failed to fetch wishlist, status: ${response.statusCode}${response.data}",
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  //add to wishlist
  Future<WishlistItem> addToWishlist({required String productId}) async {
    try {
      final response = await client.post(
        ApiConstants.addToWishlist,
        data: {"productId": productId},
      );
      if (response.statusCode == 200) {
        return WishlistItem.fromJson(response.data['wishlistItem']);
      }
      return WishlistItem.empty();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(e.message);
      }
    }
  }

  //remove from wishlist
  Future<bool> removeFromWishlist({required String productId}) async {
    try {
      final response = await client.delete(
        ApiConstants.removeFromWishlist(productId),
      );
      if (response.statusCode == 204) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
