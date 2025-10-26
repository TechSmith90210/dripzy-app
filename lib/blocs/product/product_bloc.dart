import 'package:dripzy/blocs/product/product_event.dart';
import 'package:dripzy/blocs/product/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  ProductBloc({required ProductRepository repository})
    : _productRepository = repository,
      super(ProductInitial()) {
    on<LoadSingleProduct>(_handleLoadSingleProduct);
  }

  Future<void> _handleLoadSingleProduct(
    LoadSingleProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final data = await _productRepository.getProductById(
      productId: event.productId,
    );

    data.when(
      success: (data) => emit(ProductLoaded(product: data)),
      failure: (error) => emit(ProductError(message: error.toString())),
    );
  }
}
