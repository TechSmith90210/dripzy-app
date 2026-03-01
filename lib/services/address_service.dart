import 'package:dripzy/core/api/api_constants.dart';
import 'package:dripzy/core/api/global_api_client.dart';
import 'package:dripzy/models/address/address_model.dart';

class AddressService {
  final ApiClient _apiClient;

  AddressService(this._apiClient);

  // GET /addresses
  Future<List<Address>> getAllAddresses() async {
    final response = await _apiClient.get(ApiConstants.getAllAddresses);

    final List<dynamic> addressData = response.data['addresses'];

    return addressData
        .map((e) => Address.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // POST /addresses
  Future<Address> addAddress(Address address) async {
    final response = await _apiClient.post(
      ApiConstants.addAddress,
      data: address.toJson(),
    );

    return Address.fromJson(response.data['newAddress']);
  }

  // PUT /addresses/:id
  Future<Address> updateAddress(
      String addressId, Map<String, dynamic> changes) async {
    final response = await _apiClient.put(
      ApiConstants.updateAddress(addressId),
      data: changes,
    );

    return Address.fromJson(response.data['address']);
  }

  // PATCH /addresses/:id/default
  Future<Address> setDefaultAddress(String addressId) async {
    final response = await _apiClient.patch(
      ApiConstants.setDefaultAddress(addressId),
    );

    return Address.fromJson(response.data['address']);
  }

  // DELETE /addresses/:id
  Future<void> deleteAddress(String addressId) async {
    await _apiClient.delete(ApiConstants.deleteAddress(addressId));
  }
}