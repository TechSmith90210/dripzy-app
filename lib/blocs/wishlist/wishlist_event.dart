import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class WishlistRequested extends WishlistEvent {}

class WishlistItemToggled extends WishlistEvent {
  final String productId;

  WishlistItemToggled({required this.productId});

  @override
  List<Object?> get props => [productId];
}
