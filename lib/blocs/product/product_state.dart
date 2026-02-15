import 'package:dripzy/models/product/product_model.dart';

abstract class ProductState {
  final String message;
  const ProductState({this.message = ''});
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final Product product;
  const ProductLoaded({
    required this.product,
    super.message = "Success",
  });

  ProductLoaded copyWith({String? selectedSize}) {
    return ProductLoaded(
      product: product,
    );
  }
}

class ProductError extends ProductState {
  const ProductError({super.message = "Something went wrong"});
}
