import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store regions: list + retrieve (read-only).
class CustomerRegionsResource {
  CustomerRegionsResource(this._dio);

  final Dio _dio;

  /// `GET /store/regions`.
  Future<CustomerRegionsRes> list([
    CustomerListRegionsParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/regions',
      queryParameters: query?.toQuery(),
    );
    return CustomerRegionsRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/regions/:id`.
  Future<CustomerRegionRes> retrieve(
    String regionId, [
    CustomerRetrieveRegionParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/regions/$regionId',
      queryParameters: query?.toQuery(),
    );
    return CustomerRegionRes.fromJson(res.data ?? const {});
  }
}
