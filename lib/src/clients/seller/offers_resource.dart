import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Vendor offers (`/vendor/offers*`) — direct writes, no change requests.
class SellerOffersResource {
  SellerOffersResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/offers` — the seller's own offers.
  Future<SellerOfferListRes> list([SellerListOffersParams? query]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/offers',
      queryParameters: query?.toQuery(),
    );
    return SellerOfferListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/offers` → `{offer}`.
  Future<SellerOfferRes> create(SellerCreateOfferReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/offers',
      data: body.toJson(),
    );
    return SellerOfferRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/offers/batch` → created offers list.
  Future<SellerOfferListRes> batchCreate(
    List<SellerCreateOfferReq> offers,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/offers/batch',
      data: {'offers': offers.map((o) => o.toJson()).toList()},
    );
    return SellerOfferListRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/offers/:id` → `{offer}`.
  Future<SellerOfferRes> retrieve(
    String id, [
    SellerRetrieveOfferParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/offers/$id',
      queryParameters: query?.toQuery(),
    );
    return SellerOfferRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/offers/:id` → `{offer}`.
  Future<SellerOfferRes> update(String id, SellerUpdateOfferReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/offers/$id',
      data: body.toJson(),
    );
    return SellerOfferRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/offers/:id` → deletion confirmation.
  Future<SellerOfferDeleteRes> delete(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/offers/$id',
    );
    return SellerOfferDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/offers/:id/inventory-items/batch` → `{offer}`.
  Future<SellerOfferRes> batchInventoryItems(
    String id,
    SellerOfferInventoryBatchReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/offers/$id/inventory-items/batch',
      data: body.toJson(),
    );
    return SellerOfferRes.fromJson(res.data ?? const {});
  }
}
