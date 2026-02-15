import '../product/product_model.dart';

class WishlistItem {
  final Product product;
  final DateTime addedAt;

  const WishlistItem({
    required this.product,
    required this.addedAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      product: Product.fromJson(json['product']),
      addedAt: DateTime.parse(json['addedAt']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'addedAt': addedAt.toIso8601String(),
    };
  }

  WishlistItem copyWith({
    Product? product,
    DateTime? addedAt,
  }) {
    return WishlistItem(
      product: product ?? this.product,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  factory WishlistItem.empty() {
    return WishlistItem(
      product: Product.empty,
      addedAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
