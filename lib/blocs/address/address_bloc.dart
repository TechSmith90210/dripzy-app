import 'package:dripzy/models/address/address_model.dart';
import 'package:dripzy/repositories/address_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository _addressRepository;

  AddressBloc({required AddressRepository repository}) : _addressRepository = repository, super(const AddressState()) {
    on<GetAddresses>(_handleGetAddresses);
    on<AddAddress>(_handleAddAddress);
    on<UpdateAddress>(_handleUpdateAddress);
    on<SetDefaultAddress>(_handleSetDefaultAddress);
    on<DeleteAddress>(_handleDeleteAddress);
  }

  // ---------------- GET ----------------

  Future<void> _handleGetAddresses(
      GetAddresses event,
      Emitter<AddressState> emit,
      ) async {
    emit(state.copyWith(status: AddressStatus.loading, error: null));

    final result = await _addressRepository.getAllAddresses();

    result.when(
      success: (addresses) {
        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
        ));
        emit(state.copyWith(status: AddressStatus.initial));
      },
      failure: (error) =>
          emit(state.copyWith(status: AddressStatus.failure, error: error)),
    );
  }

  // ---------------- ADD ----------------

  Future<void> _handleAddAddress(
      AddAddress event,
      Emitter<AddressState> emit,
      ) async {
    emit(state.copyWith(status: AddressStatus.loading, error: null));

    final result = await _addressRepository.addAddress(event.address);

    result.when(
      success: (address) {
        final updated = List<Address>.from(state.addresses)..add(address);

        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: updated,
        ));
        emit(state.copyWith(status: AddressStatus.initial));
      },
      failure: (message) =>
          emit(state.copyWith(status: AddressStatus.failure, error: message)),
    );
  }

  // ---------------- UPDATE ----------------

  Future<void> _handleUpdateAddress(
      UpdateAddress event,
      Emitter<AddressState> emit,
      ) async {
    emit(state.copyWith(status: AddressStatus.loading, error: null));

    final result = await _addressRepository.updateAddress(
      event.addressId,
      event.updateData,
    );

    result.when(
      success: (updatedAddress) {
        final updatedList = state.addresses
            .map((a) => a.id == updatedAddress.id ? updatedAddress : a)
            .toList();

        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: updatedList,
        ));
        emit(state.copyWith(status: AddressStatus.initial));
      },
      failure: (error) =>
          emit(state.copyWith(status: AddressStatus.failure, error: error)),
    );
  }

  // ---------------- SET DEFAULT ----------------

  Future<void> _handleSetDefaultAddress(
      SetDefaultAddress event,
      Emitter<AddressState> emit,
      ) async {
    emit(state.copyWith(status: AddressStatus.loading, error: null));

    final result = await _addressRepository.setDefaultAddress(event.addressId);

    result.when(
      success: (updatedDefault) {
        final updated = state.addresses.map((address) {
          return address.copyWith(isDefault: address.id == updatedDefault.id);
        }).toList();

        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: updated,
        ));
        emit(state.copyWith(status: AddressStatus.initial));
      },
      failure: (error) =>
          emit(state.copyWith(status: AddressStatus.failure, error: error)),
    );
  }

  // ---------------- DELETE ----------------

  Future<void> _handleDeleteAddress(
      DeleteAddress event,
      Emitter<AddressState> emit,
      ) async {
    emit(state.copyWith(status: AddressStatus.loading, error: null));

    final result = await _addressRepository.deleteAddress(event.addressId);

    result.when(
      success: (deletedId) {
        final updated =
        state.addresses.where((a) => a.id != deletedId).toList();

        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: updated,
        ));
        emit(state.copyWith(status: AddressStatus.initial));
      },
      failure: (error) =>
          emit(state.copyWith(status: AddressStatus.failure, error: error)),
    );
  }
}