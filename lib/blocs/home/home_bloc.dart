import 'package:dripzy/blocs/home/home_event.dart';
import 'package:dripzy/blocs/home/home_state.dart';
import 'package:dripzy/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository _productRepository = ProductRepository();

  HomeBloc() : super(HomeInitial()) {
    on<LoadProducts>(_loadProducts);
  }

  Future<void> _loadProducts(event, emit) async {
    emit(HomeLoading());
    final result = await _productRepository.getAllProducts();

    result.when(
      success: (data) => emit(HomeLoaded(products: data)),
      failure: (error) => HomeError(error: error),
    );
  }
}
