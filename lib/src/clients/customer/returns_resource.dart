import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store returns: file a return (`POST`, unauthenticated by design —
/// the order id is the access token) plus return-reason reads.
class CustomerReturnsResource {
  CustomerReturnsResource(this._dio);

  final Dio _dio;

  /// `POST /store/returns`.
  Future<CustomerReturnRes> create(CustomerCreateReturnReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/returns',
      data: body.toJson(),
    );
    return CustomerReturnRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/return-reasons`.
  Future<CustomerReturnReasonsRes> listReasons([
    CustomerListReturnReasonsParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/return-reasons',
      queryParameters: query?.toQuery(),
    );
    return CustomerReturnReasonsRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/return-reasons/:id`.
  Future<CustomerReturnReasonRes> retrieveReason(
    String reasonId, [
    CustomerRetrieveReturnReasonParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/return-reasons/$reasonId',
      queryParameters: query?.toQuery(),
    );
    return CustomerReturnReasonRes.fromJson(res.data ?? const {});
  }
}
