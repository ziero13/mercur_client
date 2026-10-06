import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store sellers (`GET /store/sellers`, `GET /store/sellers/:id`).
class CustomerSellersResource {
  CustomerSellersResource(this._dio);

  final Dio _dio;

  Future<CustomerSellerListRes> list([
    CustomerListSellersParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/sellers',
      queryParameters: query?.toQuery(),
    );
    return CustomerSellerListRes.fromJson(res.data ?? const {});
  }

  Future<CustomerSellerRes> retrieve(
    String id, [
    CustomerRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/sellers/$id',
      queryParameters: query?.toQuery(),
    );
    return CustomerSellerRes.fromJson(res.data ?? const {});
  }
}
