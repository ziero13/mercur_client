import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store customer account (`/store/customers/me`, addresses).
/// Customer JWT required on every call.
class CustomerCustomersResource {
  CustomerCustomersResource(this._dio);

  final Dio _dio;

  /// `GET /store/customers/me`.
  Future<CustomerRes> me([CustomerRetrieveMeParams? query]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/customers/me',
      queryParameters: query?.toQuery(),
    );
    return CustomerRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/customers/me` (email is immutable here).
  Future<CustomerRes> updateMe(CustomerUpdateReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/customers/me',
      data: body.toJson(),
    );
    return CustomerRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/customers/me/addresses`.
  Future<CustomerAddressListRes> listAddresses([
    CustomerListAddressesParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/customers/me/addresses',
      queryParameters: query?.toQuery(),
    );
    return CustomerAddressListRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/customers/me/addresses`.
  ///
  /// Verified live: returns `{customer}` (not `{address}`).
  Future<CustomerRes> createAddress(CustomerAddressReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/customers/me/addresses',
      data: body.toJson(),
    );
    return CustomerRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/customers/me/addresses/:address_id`.
  Future<CustomerAddressRes> retrieveAddress(
    String addressId, [
    CustomerRetrieveAddressParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/customers/me/addresses/$addressId',
      queryParameters: query?.toQuery(),
    );
    return CustomerAddressRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/customers/me/addresses/:address_id`.
  ///
  /// Verified live: returns `{customer}` (not `{address}`).
  Future<CustomerRes> updateAddress(
    String addressId,
    CustomerAddressReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/customers/me/addresses/$addressId',
      data: body.toJson(),
    );
    return CustomerRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /store/customers/me/addresses/:address_id`.
  ///
  /// Verified live: returns `{id (customer), object, deleted, parent}` —
  /// the returned `id` is the customer, so the result carries the
  /// requested `addressId` with the parsed `deleted` flag.
  Future<CustomerAddressDeleteRes> deleteAddress(String addressId) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/store/customers/me/addresses/$addressId',
    );
    final data = res.data ?? const {};
    return CustomerAddressDeleteRes(
      id: addressId,
      deleted: data['deleted'] as bool? ?? false,
    );
  }
}
