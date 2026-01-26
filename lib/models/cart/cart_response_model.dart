import 'package:dripzy/models/cart/price_breakdown_model.dart';

import 'cart_model.dart';

class CartResponse {
  final Cart cart;
  final PriceBreakdown priceBreakdown;

  CartResponse({required this.cart, required this.priceBreakdown});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      cart: Cart.fromJson(json['cart']),
      priceBreakdown: PriceBreakdown.fromJson(json['priceBreakdown']),
    );
  }
}
