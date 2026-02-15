import 'package:dripzy/models/wishlist/wishlist_item_model.dart';
import 'package:equatable/equatable.dart';

import '../../models/product/product_model.dart';

enum WishlistStatus { initial, loading, success, failure }

class WishlistState extends Equatable {
  final String message;
  final WishlistStatus status;
  final List<WishlistItem> products;

  const WishlistState({
    this.message = '',
    this.status = WishlistStatus.initial,
    this.products = const [],
  });

  WishlistState copyWith({
    WishlistStatus? status,
    List<WishlistItem>? products,
    String? message,
  }) {
    return WishlistState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message ?? this.message,
    );
  }

  //helper for wishlisted products
  bool isWishlisted(String productId) {
    return products.any((element) => element.product.id == productId);
  }

  @override
  List<Object> get props => [status, products, message];
}
