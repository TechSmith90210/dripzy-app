import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  final String productId;
  final String size;

  CartItemAdded({required this.productId, required this.size});

  @override
  List<Object?> get props => [productId, size];
}

class GetCartItem extends CartEvent {
  final String productId;
  final String size;

  GetCartItem({required this.productId, required this.size});

  @override
  List<Object?> get props => [productId, size];
}

class GetUserCart extends CartEvent {}

class ClearCartItemState extends CartEvent {}

class UpdateCartItemQuantity extends CartEvent {
  final String productId;
  final String size;
  final int quantity; // new quantity

  UpdateCartItemQuantity({
    required this.productId,
    required this.size,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, size, quantity];
}

class RemoveCartItem extends CartEvent {
  final String productId;
  final String size;

  RemoveCartItem({required this.productId, required this.size});
}
