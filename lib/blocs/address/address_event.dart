import 'package:dripzy/models/address/address_model.dart';
import 'package:equatable/equatable.dart';

abstract class AddressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAddresses extends AddressEvent {}

class AddAddress extends AddressEvent {
  final Address address;

  AddAddress({required this.address});

  @override
  List<Object?> get props => [address];
}

class UpdateAddress extends AddressEvent {
  final String addressId;
  final Map<String,dynamic> updateData;

  UpdateAddress({required this.addressId, required this.updateData});

  @override
  List<Object?> get props => [addressId, updateData];
}

class SetDefaultAddress extends AddressEvent {
  final String addressId;

  SetDefaultAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

class DeleteAddress extends AddressEvent {
  final String addressId;

  DeleteAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}