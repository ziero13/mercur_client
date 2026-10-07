import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Vendor orders + fulfillment (`/vendor/orders*`).
///
/// Reads are safe anytime. Mutations (complete/cancel/fulfill/ship)
/// act on real orders — only call them against orders the seller
/// actually wants to move.
class SellerOrdersResource {
  SellerOrdersResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/orders` — the seller's orders.
  Future<SellerOrderListRes> list([SellerListOrdersParams? query]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/orders',
      queryParameters: query?.toQuery(),
    );
    return SellerOrderListRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/orders/:id` → `{order}`.
  Future<SellerOrderRes> retrieve(
    String id, [
    SellerRetrieveOrderParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/orders/$id',
      queryParameters: query?.toQuery(),
    );
    return SellerOrderRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/orders/:id/preview` → `{order}` with pending edits.
  Future<SellerOrderRes> preview(
    String id, [
    SellerRetrieveOrderParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/orders/$id/preview',
      queryParameters: query?.toQuery(),
    );
    return SellerOrderRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/orders/:id/changes` → `{order_changes}`.
  Future<SellerOrderChangeListRes> changes(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/orders/$id/changes',
    );
    return SellerOrderChangeListRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/orders/:id/commission-lines`.
  Future<SellerCommissionListRes> commissionLines(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/orders/$id/commission-lines',
    );
    return SellerCommissionListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/orders/:id/complete` → `{order}`.
  Future<SellerOrderRes> complete(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/orders/$id/complete',
    );
    return SellerOrderRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/orders/:id/cancel` → `{order}`.
  Future<SellerOrderRes> cancel(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/orders/$id/cancel',
    );
    return SellerOrderRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/orders/:id/fulfillments` → `{fulfillment}`.
  Future<SellerFulfillmentRes> createFulfillment(
    String id,
    SellerCreateFulfillmentReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/orders/$id/fulfillments',
      data: body.toJson(),
    );
    return SellerFulfillmentRes.fromJson(res.data ?? const {});
  }

  /// `POST …/fulfillments/:fulfillment_id/cancel` → `{fulfillment}`.
  Future<SellerFulfillmentRes> cancelFulfillment(
    String id,
    String fulfillmentId,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/orders/$id/fulfillments/$fulfillmentId/cancel',
    );
    return SellerFulfillmentRes.fromJson(res.data ?? const {});
  }

  /// `POST …/fulfillments/:fulfillment_id/mark-as-delivered`.
  Future<SellerFulfillmentRes> markDelivered(
    String id,
    String fulfillmentId,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/orders/$id/fulfillments/$fulfillmentId/mark-as-delivered',
    );
    return SellerFulfillmentRes.fromJson(res.data ?? const {});
  }

  /// `POST …/fulfillments/:fulfillment_id/shipments` → `{order}`.
  Future<SellerOrderRes> createShipment(
    String id,
    String fulfillmentId,
    SellerCreateShipmentReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/orders/$id/fulfillments/$fulfillmentId/shipments',
      data: body.toJson(),
    );
    return SellerOrderRes.fromJson(res.data ?? const {});
  }
}
