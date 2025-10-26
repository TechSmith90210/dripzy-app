import 'package:dripzy/models/product_model.dart';

class CartProduct {
  final Product product;
  final int quantity;
  final String size;

  CartProduct({
    required this.product,
    required this.quantity,
    required this.size,
  });

  factory CartProduct.fromJson(Map<String, dynamic> data) {
    return CartProduct(
      product: Product.fromJson(data['productId']),
      quantity: data['quantity'] as int,
      size: data['size'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'productId': product.id, 'quantity': quantity, 'size': size};
  }
}

class Cart {
  final String? id;
  final String userId;
  final List<CartProduct>? products;

  Cart({this.id, required this.userId, this.products = const []});

  factory Cart.fromJson(Map<String, dynamic> data) {
    final List<dynamic>? productsJson = data['products'] as List<dynamic>?;

    return Cart(
      id: data['_id'] as String?,
      userId: data['userId'] as String,
      products:
          productsJson
              ?.map(
                (pJson) => CartProduct.fromJson(pJson as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> productJsons =
        products?.map((p) => p.toJson()).toList() ?? [];
    return {
      if (id != null) '_id': id,
      'userId': userId,
      'products': productJsons,
    };
  }
}
