import 'package:dripzy/models/product/product_model.dart';

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
  final List<CartProduct> products;

  Cart({
    this.id,
    required this.userId,
    this.products = const [],
  });

  factory Cart.fromJson(Map<String, dynamic> data) {
    return Cart(
      id: data['_id'] as String?,
      userId: data['userId'] as String,
      products: (data['products'] as List<dynamic>?)
          ?.map(
            (p) => CartProduct.fromJson(p as Map<String, dynamic>),
      )
          .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'userId': userId,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }

  Cart.empty() : id = null, userId = '', products = const [];
}
