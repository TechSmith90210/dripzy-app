import 'package:dripzy/models/cart_model.dart';

abstract class CartState {
  final String message;
  const CartState({this.message = ""});
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded({required this.cart}) : super(message: "Cart loaded");
}

class CartItemAddedSuccess extends CartState {
  const CartItemAddedSuccess({required super.message});
}

class CartItemQuantityState extends CartState {
  final String productId;
  final Map<String, int> sizeQuantityMap;

  const CartItemQuantityState({
    required this.productId,
    required this.sizeQuantityMap,
     super.message,
  });
}

class CartError extends CartState {
  const CartError({required super.message});
}


