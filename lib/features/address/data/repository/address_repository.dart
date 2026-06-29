import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_constants.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/address/data/models/add_address_request_model.dart';
import 'package:drip_talk/features/address/data/models/add_address_response_model.dart';
import 'package:drip_talk/features/address/data/models/address_list_model.dart';

class AddressRepository {
  AddressRepository(this._apiService);

  final ApiService _apiService;

  Future<AddressListResponseModel> getAddresses({
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.addresses,
      cancelToken: cancelToken,
    );

    return AddressListResponseModel.fromJson(_asMap(response.data));
  }

  Future<AddAddressResponseModel> addAddress(
    AddAddressRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.addresses,
      data: request.toFormData(),
      options: Options(contentType: ApiConstants.multiPart),
      cancelToken: cancelToken,
    );

    return AddAddressResponseModel.fromJson(_asMap(response.data));
  }

  Future<AddAddressResponseModel> updateAddress({
    required int addressId,
    required AddAddressRequestModel request,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.updateAddress(addressId),
      data: request.toFormData(),
      options: Options(contentType: ApiConstants.multiPart),
      cancelToken: cancelToken,
    );

    return AddAddressResponseModel.fromJson(_asMap(response.data));
  }

  Future<AddAddressResponseModel> deleteAddress({
    required int addressId,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.delete(
      ApiEndpoints.deleteAddress(addressId),
      cancelToken: cancelToken,
    );

    return AddAddressResponseModel.fromJson(_asMap(response.data));
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}
