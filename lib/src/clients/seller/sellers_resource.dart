import 'package:dio/dio.dart';

import '../../models/models.dart';
import '../auth_sink.dart';

/// Vendor sellers + scope (`/vendor/sellers*`).
///
/// Onboarding order: [list] (unscoped memberships) → [select] (installs
/// the scope) → [retrieveCurrent] / [updateCurrent].
class SellerSellersResource {
  SellerSellersResource(this._dio, {this.onSellerSelected});

  final Dio _dio;
  final SellerScopeSink? onSellerSelected;

  /// `GET /vendor/sellers` — memberships, no `x-seller-id` required.
  Future<SellerMembershipListRes> list([
    SellerListMembershipsParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/sellers',
      queryParameters: query?.toQuery(),
    );
    return SellerMembershipListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/sellers` — public registration.
  Future<SellerCreateRes> create(SellerCreateReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/sellers',
      data: body.toJson(),
    );
    return SellerCreateRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/sellers/select` — installs the scope on success.
  Future<SellerSelectRes> select(SellerSelectReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/sellers/select',
      data: body.toJson(),
    );
    final parsed = SellerSelectRes.fromJson(res.data ?? const {});
    if (parsed.success && parsed.sellerId.isNotEmpty) {
      onSellerSelected?.call(parsed.sellerId);
    }
    return parsed;
  }

  /// `GET /vendor/sellers/me` — scoped current seller.
  Future<SellerCurrentRes> retrieveCurrent([
    SellerRetrieveCurrentParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/sellers/me',
      queryParameters: query?.toQuery(),
    );
    return SellerCurrentRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/sellers/me` — update scoped current seller.
  Future<SellerCurrentRes> updateCurrent(SellerUpdateCurrentReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/sellers/me',
      data: body.toJson(),
    );
    return SellerCurrentRes.fromJson(res.data ?? const {});
  }
}
