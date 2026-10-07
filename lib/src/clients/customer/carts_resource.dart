import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store carts: full checkout flow — create, retrieve, update, offer
/// line-items, promotions, shipping methods, taxes, then complete into
/// per-seller orders under one order group.
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

  /// `GET /store/carts/:id`.
  Future<CustomerCartRes> retrieve(
    String cartId, [
    CustomerRetrieveCartParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/carts/$cartId',
      queryParameters: query?.toQuery(),
    );
    return CustomerCartRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/carts/:id` — email, region, addresses…
  Future<CustomerCartRes> update(
    String cartId,
    CustomerUpdateCartReq body, [
    CustomerRetrieveCartParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/carts/$cartId',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
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

  /// `POST /store/carts/:id/line-items/:line_id` — `quantity: 0` removes.
  Future<CustomerCartRes> updateLineItem(
    String cartId,
    String lineId,
    CustomerUpdateLineItemReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/carts/$cartId/line-items/$lineId',
      data: body.toJson(),
    );
    return CustomerCartRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /store/carts/:id/line-items/:line_id`.
  Future<CustomerDeleteLineItemRes> removeLineItem(
    String cartId,
    String lineId,
  ) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/store/carts/$cartId/line-items/$lineId',
    );
    return CustomerDeleteLineItemRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/carts/:id/customer` — attach the cart to the logged-in
  /// customer (requires customer Bearer).
  Future<CustomerCartRes> attachCustomer(String cartId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/carts/$cartId/customer',
      data: const {},
    );
    return CustomerCartRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/carts/:id/promotions` — empty [promoCodes] clears.
  Future<CustomerCartRes> applyPromotions(
    String cartId,
    CustomerCartPromotionsReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/carts/$cartId/promotions',
      data: body.toJson(),
    );
    return CustomerCartRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /store/carts/:id/promotions`.
  Future<CustomerCartRes> removePromotions(
    String cartId,
    CustomerCartPromotionsReq body,
  ) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/store/carts/$cartId/promotions',
      data: body.toJson(),
    );
    return CustomerCartRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/carts/:id/shipping-methods` — single option.
  Future<CustomerCartRes> addShippingMethod(
    String cartId,
    CustomerAddShippingMethodReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/carts/$cartId/shipping-methods',
      data: body.toJson(),
    );
    return CustomerCartRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/carts/:id/shipping-methods` — batch (one per seller).
  Future<CustomerCartRes> addShippingMethods(
    String cartId,
    List<CustomerAddShippingMethodReq> body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/carts/$cartId/shipping-methods',
      data: body.map((b) => b.toJson()).toList(),
    );
    return CustomerCartRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/carts/:id/taxes` — force tax (re)calculation.
  Future<CustomerCartRes> refreshTaxes(String cartId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/carts/$cartId/taxes',
      data: const {},
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
