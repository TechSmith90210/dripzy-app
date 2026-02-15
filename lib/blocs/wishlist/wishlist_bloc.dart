import 'package:dripzy/blocs/wishlist/wishlist_event.dart';
import 'package:dripzy/blocs/wishlist/wishlist_state.dart';
import 'package:dripzy/repositories/wishlist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _wishlistRepository;

  WishlistBloc({required WishlistRepository repository})
    : _wishlistRepository = repository,
      super(WishlistState()) {
    on<WishlistRequested>(_handleWishlistRequested);
    on<WishlistItemToggled>(_handleWishlistItemToggled);
  }

  Future<void> _handleWishlistRequested(
    WishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(status: WishlistStatus.loading));
    //call api
    final data = await _wishlistRepository.getWishlist();

    data.when(
      success: (data) {
        emit(
          state.copyWith(status: WishlistStatus.success, products: data.items),
        );
      },
      failure: (error) {
        emit(state.copyWith(status: WishlistStatus.failure));
      },
    );
  }

  Future<void> _handleWishlistItemToggled(
    WishlistItemToggled event,
    Emitter<WishlistState> emit,
  ) async {
    //check if the product is already in the wishlist
    final bool doesProductExist = state.products.any(
      (e) => e.product.id == event.productId,
    );

    if (doesProductExist) {
      //if product exists, remove it
      final removeResult = await _wishlistRepository.removeFromWishlist(
        event.productId,
      );
      removeResult.when(
        success: (data) {
          //remove the product from the state and send new list back
          final updatedList =
              state.products
                  .where((e) => e.product.id != event.productId)
                  .toList();
          emit(
            state.copyWith(
              status: WishlistStatus.success,
              message: "Product removed from wishlist",
              products: updatedList,
            ),
          );
        },
        failure:
            (error) => {
              emit(
                state.copyWith(
                  status: WishlistStatus.failure,
                  message: "Unable to remove product from wishlist: $error",
                ),
              ),
            },
      );
    } else {
      //if product does not exist, add it
      final addResult = await _wishlistRepository.addToWishlist(
        event.productId,
      );
      addResult.when(
        success: (data) {
          //add the product to the state and send new list back
          final updatedList = [...state.products, data];
          emit(
            state.copyWith(
              status: WishlistStatus.success,
              message: "Product added to wishlist",
              products: updatedList,
            ),
          );
        },
        failure:
            (error) => {
              emit(
                state.copyWith(
                  status: WishlistStatus.failure,
                  message: "Unable to add product to wishlist: $error",
                ),
              ),
            },
      );
    }
  }
}
