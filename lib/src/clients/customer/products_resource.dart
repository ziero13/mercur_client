import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store products (`GET /store/products`, `GET /store/products/:id`).
///
/// Customer auth is optional; when set it enriches the pricing context.
class CustomerProductsResource {
  CustomerProductsResource(this._dio);

  final Dio _dio;

  Future<CustomerProductListRes> list([
    CustomerListProductsParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/products',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductListRes.fromJson(res.data ?? const {});
  }

  Future<CustomerProductRes> retrieve(
    String id, [
    CustomerRetrieveProductParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/products/$id',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductRes.fromJson(res.data ?? const {});
  }
}
