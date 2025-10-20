import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSingleProduct extends ProductEvent {
  final String productId;
  LoadSingleProduct({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class SelectProductSize extends ProductEvent {
  final String size;
  SelectProductSize({required this.size});

  @override
  List<Object?> get props => [size];
}