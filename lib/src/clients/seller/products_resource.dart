import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Vendor products + variants (`/vendor/products*`,
/// `/vendor/product-variants`).
///
/// Products are shared master records: updates, deletes, variant and
/// attribute writes stage a pending change request (`product_change`,
/// 202) that an operator confirms — they never write directly.
class SellerProductsResource {
  SellerProductsResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/products` — own + visible catalog products.
  Future<SellerProductListRes> list([
    SellerListProductsParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/products',
      queryParameters: query?.toQuery(),
    );
    return SellerProductListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/products` — created as `draft`/`proposed`.
  Future<SellerProductRes> create(SellerCreateProductReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/products',
      data: body.toJson(),
    );
    return SellerProductRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/products/:id`.
  Future<SellerProductRes> retrieve(
    String id, [
    SellerRetrieveProductParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/products/$id',
      queryParameters: query?.toQuery(),
    );
    return SellerProductRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/products/:id` → staged `product_change`.
  Future<SellerProductChangeRes> update(
    String id,
    SellerUpdateProductReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/products/$id',
      data: body.toJson(),
    );
    return SellerProductChangeRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/products/:id` → staged `PRODUCT_DELETE` change.
  Future<SellerProductChangeRes> delete(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/products/$id',
    );
    return SellerProductChangeRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/products/:id/preview` → pending change or null.
  Future<SellerProductChangeRes> preview(
    String id, [
    SellerRetrieveProductParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/products/$id/preview',
      queryParameters: query?.toQuery(),
    );
    return SellerProductChangeRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/products/:id/cancel` → canceled change.
  Future<SellerProductChangeRes> cancel(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/products/$id/cancel',
    );
    return SellerProductChangeRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/products/:id/variants`.
  Future<SellerVariantListRes> listVariants(
    String id, [
    SellerListVariantsParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/products/$id/variants',
      queryParameters: query?.toQuery(),
    );
    return SellerVariantListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/products/:id/variants` → staged `VARIANT_ADD` (202).
  Future<SellerProductChangeRes> createVariant(
    String id,
    SellerVariantReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/products/$id/variants',
      data: body.toJson(),
    );
    return SellerProductChangeRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/products/:id/variants/:variant_id`.
  Future<SellerVariantRes> retrieveVariant(String id, String variantId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/products/$id/variants/$variantId',
    );
    return SellerVariantRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/products/:id/variants/:variant_id` → staged change.
  Future<SellerProductChangeRes> updateVariant(
    String id,
    String variantId,
    SellerVariantReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/products/$id/variants/$variantId',
      data: body.toJson(),
    );
    return SellerProductChangeRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/products/:id/variants/:variant_id` → staged change.
  Future<SellerProductChangeRes> deleteVariant(
    String id,
    String variantId,
  ) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/products/$id/variants/$variantId',
    );
    return SellerProductChangeRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/products/:id/attributes/batch` → staged change.
  Future<SellerProductChangeRes> batchAttributes(
    String id,
    SellerAttributesBatchReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/products/$id/attributes/batch',
      data: body.toJson(),
    );
    return SellerProductChangeRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/product-variants` — variants across products.
  Future<SellerVariantListRes> listAllVariants([
    SellerListVariantsParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/product-variants',
      queryParameters: query?.toQuery(),
    );
    return SellerVariantListRes.fromJson(res.data ?? const {});
  }
}
