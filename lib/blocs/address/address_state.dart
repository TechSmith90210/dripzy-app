import 'package:equatable/equatable.dart'; // 1. Add this import
import 'package:dripzy/models/address/address_model.dart';

enum AddressStatus { initial, loading, success, failure }

// 2. Extend Equatable
class AddressState extends Equatable {
  final AddressStatus status;
  final List<Address> addresses;
  final String? error;
  final String? selectedId;

  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.error,
    this.selectedId,
  });

  AddressState copyWith({
    AddressStatus? status,
    List<Address>? addresses,
    String? error,
    String? selectedId,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      error: error,
      selectedId: selectedId ?? this.selectedId,
    );
  }

  // 3. 🟢 THIS IS THE KEY: Include all fields here
  @override
  List<Object?> get props => [status, addresses, error, selectedId];
}