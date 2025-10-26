import 'package:dripzy/repositories/cart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  // Store per-size quantities for the current product on this screen
  final Map<String, int> _sizeQuantityMap = {};

  Map<String, int> get sizeQuantityMap => Map.unmodifiable(_sizeQuantityMap);


  CartBloc({required CartRepository repository})
    : _cartRepository = repository,
      super(CartInitial()) {
    on<GetCartItem>(_handleGetCartItem);
    on<GetUserCart>(_handleGetCart);
    on<CartItemAdded>(_handleAddItemToCart);
    on<ClearCartItemState>(_handleClearCartItemState);
    on<UpdateCartItemQuantity>(_handleUpdateCartItemQuantity);
  }

  Future<void> _handleGetCartItem(
    GetCartItem event,
    Emitter<CartState> emit,
  ) async {
    // Check if quantity already exists in map
    if (_sizeQuantityMap.containsKey(event.size)) {
      emit(
        CartItemQuantityState(
          productId: event.productId,
          sizeQuantityMap: Map.from(_sizeQuantityMap),
          // message: "Item fetched from cart",
        ),
      );
      return;
    }

    emit(CartLoading());

    final data = await _cartRepository.getCartItem(
      productId: event.productId,
      size: event.size,
    );

    data.when(
      success: (quantity) {
        _sizeQuantityMap[event.size] = quantity;
        emit(
          CartItemQuantityState(
            productId: event.productId,
            sizeQuantityMap: Map.from(_sizeQuantityMap),
            // message: "Item fetched from cart",
          ),
        );
      },
      failure: (error) => emit(CartError(message: error)),
    );
  }

  Future<void> _handleGetCart(
    GetUserCart event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());

    final data = await _cartRepository.getCart();

    data.when(
      success: (data) => emit(CartLoaded(cart: data)),
      failure: (error) => emit(CartError(message: error)),
    );
  }

  Future<void> _handleAddItemToCart(
      CartItemAdded event,
      Emitter<CartState> emit,
      ) async {
    // Optimistic update: increase local quantity immediately
    _sizeQuantityMap[event.size] = (_sizeQuantityMap[event.size] ?? 0) + 1;
    emit(
      CartItemQuantityState(
        productId: event.productId,
        sizeQuantityMap: Map.from(_sizeQuantityMap),
        message: "Adding item...",
      ),
    );

    // Call repository
    final result = await _cartRepository.addItemToCart(
      productId: event.productId,
      size: event.size,
    );

    if (result.isSuccess) {
      emit(
        CartItemQuantityState(
          productId: event.productId,
          sizeQuantityMap: Map.from(_sizeQuantityMap),
          message: "Item added to cart",
        ),
      );
    }
   else  if (result.isFailure) {
      // _sizeQuantityMap[event.size] = (_sizeQuantityMap[event.size] ?? 1) - 1;
      emit(
        CartItemQuantityState(
          productId: event.productId,
          sizeQuantityMap: Map.from(_sizeQuantityMap),
          message: "Failed to add item",
        ),
      );
    }

  }


  Future<void> _handleUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {

    print("Size is ${event.size}");
    _sizeQuantityMap[event.size] = event.quantity;

    print("the map is updated: $_sizeQuantityMap");

    final data = await _cartRepository.updateCartItem(
      productId: event.productId,
      size: event.size,
      quantity: event.quantity,
    );

    data.when(
      success:
          (data) => emit(
            CartItemQuantityState(
              productId: event.productId,
              sizeQuantityMap: Map.from(_sizeQuantityMap),
              message: "Successfully updated quantity",
            ),
          ),
      failure: (error) {
        print("hey $error");
        emit(CartError(message: error));}
    );
  }

  void _handleClearCartItemState(
    ClearCartItemState event,
    Emitter<CartState> emit,
  ) {
    _sizeQuantityMap.clear(); // clear cached quantities
    emit(CartInitial());
  }
}
