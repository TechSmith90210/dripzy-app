import 'package:dripzy/models/product_model.dart';

abstract class ProductState {
  final String message;
  const ProductState({this.message = ''});
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final Product product;
  final String? selectedSize;
  const ProductLoaded({
    required this.product,
    this.selectedSize,
    super.message = "Success",
  });

  ProductLoaded copyWith({String? selectedSize}) {
    return ProductLoaded(
      product: product,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }
}

class ProductError extends ProductState {
  const ProductError({super.message = "Something went wrong"});
}
