import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store carts: create, add offer line-items, complete into per-seller
/// orders under one order group.
class CustomerCartsResource {
  CustomerCartsResource(this._dio);

  final Dio _dio;

  /// `POST /store/carts`.
  Future<CustomerCartRes> create(CustomerCreateCartReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/carts',
      data: body.toJson(),
    );
    return CustomerCartRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/carts/:id/line-items` — by `offer_id`, never `variant_id`.
  Future<CustomerCartRes> addLineItem(
    String cartId,
    CustomerAddLineItemReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/carts/$cartId/line-items',
      data: body.toJson(),
    );
    return CustomerCartRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/carts/:id/complete` — splits into per-seller orders.
  Future<CustomerCompleteCartRes> complete(
    String cartId, [
    CustomerCompleteCartParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/carts/$cartId/complete',
      queryParameters: query?.toQuery(),
    );
    return CustomerCompleteCartRes.fromJson(res.data ?? const {});
  }
}
