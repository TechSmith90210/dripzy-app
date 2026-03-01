import 'package:dripzy/core/utils/result.dart';
import 'package:dripzy/models/address/address_model.dart';
import 'package:dripzy/services/address_service.dart';

class AddressRepository {
  final AddressService _service;

  AddressRepository(this._service);

  Future<Result<List<Address>>> getAllAddresses() async {
    try {
      final data = await _service.getAllAddresses();
      return Result.success(data);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Address>> addAddress(Address address) async {
    try {
      final data = await _service.addAddress(address);
      return Result.success(data);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Address>> updateAddress(
      String addressId, Map<String, dynamic> changes) async {
    try {
      final data = await _service.updateAddress(addressId, changes);
      return Result.success(data);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // return updated address
  Future<Result<Address>> setDefaultAddress(String addressId) async {
    try {
      final updated = await _service.setDefaultAddress(addressId);
      return Result.success(updated);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // return removed id
  Future<Result<String>> deleteAddress(String addressId) async {
    try {
      await _service.deleteAddress(addressId);
      return Result.success(addressId);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}