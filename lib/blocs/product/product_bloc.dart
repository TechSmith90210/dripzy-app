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
    on<SelectProductSize>(_handleSelectProductSize);
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

  void _handleSelectProductSize(
    SelectProductSize event,
    Emitter<ProductState> emit,
  ) {
    final state = this.state;

    if (state is ProductLoaded) {
      final newSelectedSize =
          (state.selectedSize?.toUpperCase() == event.size.toUpperCase())
              ? ""
              : event.size;
      emit(state.copyWith(selectedSize: newSelectedSize));
    }
  }
}
