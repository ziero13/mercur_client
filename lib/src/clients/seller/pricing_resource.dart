import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Vendor price lists + campaigns (`/vendor/price-lists*`,
/// `/vendor/campaigns*`).
class SellerPricingResource {
  SellerPricingResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/price-lists`.
  Future<SellerPriceListRes> listPriceLists([
    SellerListPricingParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/price-lists',
      queryParameters: query?.toQuery(),
    );
    return SellerPriceListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/price-lists` (201) → `{price_list}`.
  Future<SellerPriceListDetailRes> createPriceList(
    SellerCreatePriceListReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/price-lists',
      data: body.toJson(),
    );
    return SellerPriceListDetailRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/price-lists/:id` → `{price_list}`.
  Future<SellerPriceListDetailRes> retrievePriceList(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/price-lists/$id',
    );
    return SellerPriceListDetailRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/price-lists/:id` → `{price_list}`.
  Future<SellerPriceListDetailRes> updatePriceList(
    String id,
    SellerUpdatePriceListReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/price-lists/$id',
      data: body.toJson(),
    );
    return SellerPriceListDetailRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/price-lists/:id` → deletion confirmation.
  Future<SellerPricingDeleteRes> deletePriceList(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/price-lists/$id',
    );
    return SellerPricingDeleteRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/price-lists/:id/prices`.
  Future<SellerPriceListPricesRes> listPrices(
    String id, [
    SellerListPricesParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/price-lists/$id/prices',
      queryParameters: query?.toQuery(),
    );
    return SellerPriceListPricesRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/price-lists/:id/prices/batch`
  /// → `{created, updated, deleted}`.
  Future<SellerPriceBatchRes> batchPrices(
    String id,
    SellerPriceBatchReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/price-lists/$id/prices/batch',
      data: body.toJson(),
    );
    return SellerPriceBatchRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/price-lists/:id/products` → `{price_list}`.
  Future<SellerPriceListDetailRes> updateListProducts(
    String id,
    SellerPriceListProductsReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/price-lists/$id/products',
      data: body.toJson(),
    );
    return SellerPriceListDetailRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/campaigns`.
  Future<SellerCampaignListRes> listCampaigns([
    SellerListPricingParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/campaigns',
      queryParameters: query?.toQuery(),
    );
    return SellerCampaignListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/campaigns` → `{campaign}`.
  Future<SellerCampaignDetailRes> createCampaign(
    SellerCreateCampaignReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/campaigns',
      data: body.toJson(),
    );
    return SellerCampaignDetailRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/campaigns/:id` → `{campaign}`.
  Future<SellerCampaignDetailRes> retrieveCampaign(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/campaigns/$id',
    );
    return SellerCampaignDetailRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/campaigns/:id` → `{campaign}`.
  Future<SellerCampaignDetailRes> updateCampaign(
    String id,
    SellerUpdateCampaignReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/campaigns/$id',
      data: body.toJson(),
    );
    return SellerCampaignDetailRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/campaigns/:id` → deletion confirmation.
  Future<SellerPricingDeleteRes> deleteCampaign(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/campaigns/$id',
    );
    return SellerPricingDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/campaigns/:id/promotions` → `{campaign}`.
  Future<SellerCampaignDetailRes> updatePromotions(
    String id,
    SellerCampaignPromotionsReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/campaigns/$id/promotions',
      data: body.toJson(),
    );
    return SellerCampaignDetailRes.fromJson(res.data ?? const {});
  }
}
