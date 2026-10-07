import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Vendor order edits (`/vendor/order-edits*`).
///
/// Flow: [create] → stage item/shipping actions → [request] →
/// [confirm]. [cancel] removes a staged edit. There is no list or
/// detail route — track edits via `GET /vendor/orders/:id/changes`
/// and `…/preview` on [SellerOrdersResource].
class SellerOrderEditsResource {
  SellerOrderEditsResource(this._dio);

  final Dio _dio;

  /// `POST /vendor/order-edits` → `{order_change}`.
  Future<ProductChange> create(OrderEditCreateReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/order-edits',
      data: body.toJson(),
    );
    return ProductChange.fromJson(
        (res.data ?? const {})['order_change'] as Map<String, dynamic>);
  }

  /// `DELETE /vendor/order-edits/:order_id` — cancels the order's
  /// pending edit (`:id` is the ORDER id, not the change id).
  Future<SellerStockDeleteRes> cancel(String orderId) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/order-edits/$orderId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/items` → `{order_change}`.
  Future<SellerRmaEnvelope> addItems(
    String id,
    OrderEditAddItemsReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/order-edits/$id/items',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/items/[action_id]` → `{order_change}`.
  Future<SellerRmaEnvelope> updateItemAction(
    String id,
    String actionId,
    OrderEditUpdateItemReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/order-edits/$id/items/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/:id/items/[action_id]` → deletion confirmation.
  Future<SellerStockDeleteRes> removeItemAction(
    String id,
    String actionId,
  ) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/order-edits/$id/items/$actionId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/items/item/[item_id]` → `{order_change}`.
  Future<SellerRmaEnvelope> setItemQuantity(
    String id,
    String itemId,
    OrderEditSetItemQuantityReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/order-edits/$id/items/item/$itemId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/shipping-method` → `{order_change}`.
  Future<SellerRmaEnvelope> addShipping(
    String id,
    RmaShippingReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/order-edits/$id/shipping-method',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/shipping-method/[action_id]` → `{order_change}`.
  Future<SellerRmaEnvelope> updateShippingAction(
    String id,
    String actionId,
    RmaShippingActionReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/order-edits/$id/shipping-method/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/:id/shipping-method/[action_id]` → deletion confirmation.
  Future<SellerStockDeleteRes> removeShippingAction(
    String id,
    String actionId,
  ) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/order-edits/$id/shipping-method/$actionId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/request` → `{order_preview}`.
  Future<SellerRmaEnvelope> request(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/order-edits/$id/request',
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/confirm` → `{order_preview}`.
  Future<SellerRmaEnvelope> confirm(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/order-edits/$id/confirm',
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }
}

/// Vendor returns (`/vendor/returns*`).
///
/// Flow: [create] → stage request-items/shipping → [request] → receive
/// ([startReceive] → [receiveItems] → [confirmReceive]) or [cancel].
class SellerReturnsResource {
  SellerReturnsResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/returns`.
  Future<SellerReturnListRes> list([SellerRmaListParams? query]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/returns',
      queryParameters: query?.toQuery(),
    );
    return SellerReturnListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/returns` → `{order, return}`.
  Future<SellerRmaEnvelope> create(ReturnCreateReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/returns/:id` → `{return}`.
  Future<SellerReturnDetailRes> retrieve(
    String id, [
    SellerRmaRetrieveParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/returns/$id',
      queryParameters: query?.toQuery(),
    );
    return SellerReturnDetailRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/returns/:id` → `{order_preview, return}`.
  Future<SellerRmaEnvelope> update(String id, ReturnUpdateReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/request-items` → `{order_preview, return}`.
  Future<SellerRmaEnvelope> requestItems(
    String id,
    ReturnRequestItemsReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/request-items',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/request-items/[action_id]`.
  Future<SellerRmaEnvelope> updateRequestItemAction(
    String id,
    String actionId,
    RmaItemActionReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/request-items/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/:id/request-items/[action_id]`.
  Future<SellerStockDeleteRes> removeRequestItemAction(
    String id,
    String actionId,
  ) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/returns/$id/request-items/$actionId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/shipping-method`.
  Future<SellerRmaEnvelope> addShipping(
    String id,
    RmaShippingReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/shipping-method',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/shipping-method/[action_id]`.
  Future<SellerRmaEnvelope> updateShippingAction(
    String id,
    String actionId,
    RmaShippingActionReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/shipping-method/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/:id/shipping-method/[action_id]`.
  Future<SellerStockDeleteRes> removeShippingAction(
    String id,
    String actionId,
  ) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/returns/$id/shipping-method/$actionId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/dismiss-items`.
  Future<SellerRmaEnvelope> dismissItems(
    String id,
    ReturnRequestItemsReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/dismiss-items',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/dismiss-items/[action_id]`.
  Future<SellerRmaEnvelope> updateDismissItemAction(
    String id,
    String actionId,
    RmaItemActionReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/dismiss-items/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/request` → `{order_preview, return}`.
  Future<SellerRmaEnvelope> request(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/request',
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/:id/request` → deletes the return, clearing its change.
  Future<SellerStockDeleteRes> cancelRequest(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/returns/$id/request',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/receive` → `{order, return}`.
  Future<SellerRmaEnvelope> startReceive(
    String id,
    ReturnReceiveReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/receive',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/receive-items`.
  Future<SellerRmaEnvelope> receiveItems(
    String id,
    ReturnReceiveItemsReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/receive-items',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/receive-items/[action_id]`.
  Future<SellerRmaEnvelope> updateReceiveItemAction(
    String id,
    String actionId,
    RmaItemActionReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/receive-items/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/receive/confirm` → `{order_preview, return}`.
  Future<SellerRmaEnvelope> confirmReceive(
    String id, [
    RmaConfirmReq? body,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/receive/confirm',
      data: body?.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/cancel` → `{order_preview, return}`.
  Future<SellerRmaEnvelope> cancel(String id, [RmaConfirmReq? body]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/returns/$id/cancel',
      data: body?.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }
}

/// Shared inbound/outbound staging for claims and exchanges.
abstract class RmaDirectionalMixin {
  Dio get dio;
  String get base;

  /// `POST …/inbound/items`.
  Future<SellerRmaEnvelope> addInboundItems(
    String id,
    RmaInboundReq body,
  ) async {
    final res = await dio.post<Map<String, dynamic>>(
      '$base/$id/inbound/items',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/inbound/items/[action_id]`.
  Future<SellerRmaEnvelope> updateInboundItemAction(
    String id,
    String actionId,
    RmaItemActionReq body,
  ) async {
    final res = await dio.post<Map<String, dynamic>>(
      '$base/$id/inbound/items/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/inbound/items/[action_id]`.
  Future<SellerStockDeleteRes> removeInboundItemAction(
    String id,
    String actionId,
  ) async {
    final res = await dio.delete<Map<String, dynamic>>(
      '$base/$id/inbound/items/$actionId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/inbound/shipping-method`.
  Future<SellerRmaEnvelope> addInboundShipping(
    String id,
    RmaShippingReq body,
  ) async {
    final res = await dio.post<Map<String, dynamic>>(
      '$base/$id/inbound/shipping-method',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/inbound/shipping-method/[action_id]`.
  Future<SellerRmaEnvelope> updateInboundShippingAction(
    String id,
    String actionId,
    RmaShippingActionReq body,
  ) async {
    final res = await dio.post<Map<String, dynamic>>(
      '$base/$id/inbound/shipping-method/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/inbound/shipping-method/[action_id]`.
  Future<SellerStockDeleteRes> removeInboundShippingAction(
    String id,
    String actionId,
  ) async {
    final res = await dio.delete<Map<String, dynamic>>(
      '$base/$id/inbound/shipping-method/$actionId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/outbound/items`.
  Future<SellerRmaEnvelope> addOutboundItems(
    String id,
    RmaOutboundReq body,
  ) async {
    final res = await dio.post<Map<String, dynamic>>(
      '$base/$id/outbound/items',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/outbound/items/[action_id]`.
  Future<SellerRmaEnvelope> updateOutboundItemAction(
    String id,
    String actionId,
    RmaItemActionReq body,
  ) async {
    final res = await dio.post<Map<String, dynamic>>(
      '$base/$id/outbound/items/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/outbound/items/[action_id]`.
  Future<SellerStockDeleteRes> removeOutboundItemAction(
    String id,
    String actionId,
  ) async {
    final res = await dio.delete<Map<String, dynamic>>(
      '$base/$id/outbound/items/$actionId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/outbound/shipping-method`.
  Future<SellerRmaEnvelope> addOutboundShipping(
    String id,
    RmaShippingReq body,
  ) async {
    final res = await dio.post<Map<String, dynamic>>(
      '$base/$id/outbound/shipping-method',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/outbound/shipping-method/[action_id]`.
  Future<SellerRmaEnvelope> updateOutboundShippingAction(
    String id,
    String actionId,
    RmaShippingActionReq body,
  ) async {
    final res = await dio.post<Map<String, dynamic>>(
      '$base/$id/outbound/shipping-method/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/outbound/shipping-method/[action_id]`.
  Future<SellerStockDeleteRes> removeOutboundShippingAction(
    String id,
    String actionId,
  ) async {
    final res = await dio.delete<Map<String, dynamic>>(
      '$base/$id/outbound/shipping-method/$actionId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }
}

/// Vendor claims (`/vendor/claims*`).
///
/// Flow: [create] (`refund`|`replace`) → stage claim-items / inbound /
/// outbound → [request] (or [cancel]).
class SellerClaimsResource extends RmaDirectionalMixin {
  SellerClaimsResource(this._dio);

  final Dio _dio;

  @override
  Dio get dio => _dio;

  @override
  String get base => '/vendor/claims';

  /// `GET /vendor/claims`.
  Future<SellerClaimListRes> list([SellerRmaListParams? query]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/claims',
      queryParameters: query?.toQuery(),
    );
    return SellerClaimListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/claims` → `{claim: {id}}`.
  Future<RmaIdRef> create(ClaimCreateReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/claims',
      data: body.toJson(),
    );
    return RmaIdRef.fromJson(
        (res.data ?? const {})['claim'] as Map<String, dynamic>);
  }

  /// `GET /vendor/claims/:id` → `{claim}`.
  Future<SellerClaimDetailRes> retrieve(
    String id, [
    SellerRmaRetrieveParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/claims/$id',
      queryParameters: query?.toQuery(),
    );
    return SellerClaimDetailRes.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/claim-items`.
  Future<SellerRmaEnvelope> addClaimItems(
    String id,
    ClaimItemsReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/claims/$id/claim-items',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/claim-items/[action_id]`.
  Future<SellerRmaEnvelope> updateClaimItemAction(
    String id,
    String actionId,
    ClaimItemsActionReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/claims/$id/claim-items/$actionId',
      data: body.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/:id/claim-items/[action_id]`.
  Future<SellerStockDeleteRes> removeClaimItemAction(
    String id,
    String actionId,
  ) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/claims/$id/claim-items/$actionId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/request` → `{order_preview}`.
  Future<SellerRmaEnvelope> request(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/claims/$id/request',
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/:id/request` → deletes the claim, clearing its change.
  Future<SellerStockDeleteRes> cancelRequest(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/claims/$id/request',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/cancel` → `{claim}`.
  Future<SellerClaimDetailRes> cancel(
    String id, [
    RmaConfirmReq? body,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/claims/$id/cancel',
      data: body?.toJson(),
    );
    return SellerClaimDetailRes.fromJson(res.data ?? const {});
  }
}

/// Vendor exchanges (`/vendor/exchanges*`).
///
/// Flow: [create] → stage inbound (return) / outbound (new items) →
/// [request] (or [cancel]). No direct detail route — track via list
/// filters and order changes.
class SellerExchangesResource extends RmaDirectionalMixin {
  SellerExchangesResource(this._dio);

  final Dio _dio;

  @override
  Dio get dio => _dio;

  @override
  String get base => '/vendor/exchanges';

  /// `GET /vendor/exchanges`.
  Future<SellerExchangeListRes> list([SellerRmaListParams? query]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/exchanges',
      queryParameters: query?.toQuery(),
    );
    return SellerExchangeListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/exchanges` → `{exchange: {id}}`.
  Future<RmaIdRef> create(ExchangeCreateReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/exchanges',
      data: body.toJson(),
    );
    return RmaIdRef.fromJson(
        (res.data ?? const {})['exchange'] as Map<String, dynamic>);
  }

  /// `POST …/:id/request` → `{order_preview}`.
  Future<SellerRmaEnvelope> request(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/exchanges/$id/request',
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }

  /// `DELETE …/:id/request` → deletes the exchange, clearing its change.
  Future<SellerStockDeleteRes> cancelRequest(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/exchanges/$id/request',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST …/:id/cancel` → `{exchange}`.
  Future<SellerRmaEnvelope> cancel(String id, [RmaConfirmReq? body]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/exchanges/$id/cancel',
      data: body?.toJson(),
    );
    return SellerRmaEnvelope.fromJson(res.data ?? const {});
  }
}
