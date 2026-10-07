import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store catalog reads (all read-only): collections, categories, tags,
/// types, attributes, options, variants — list + retrieve each.
class CustomerCatalogResource {
  CustomerCatalogResource(this._dio);

  final Dio _dio;

  /// `GET /store/collections`.
  Future<CustomerCollectionsRes> listCollections([
    CustomerCatalogListParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/collections',
      queryParameters: query?.toQuery(),
    );
    return CustomerCollectionsRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/collections/:id`.
  Future<CustomerCollectionRes> retrieveCollection(
    String collectionId, [
    CustomerCatalogRetrieveParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/collections/$collectionId',
      queryParameters: query?.toQuery(),
    );
    return CustomerCollectionRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-categories`.
  Future<CustomerCategoriesRes> listCategories([
    CustomerCatalogListParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-categories',
      queryParameters: query?.toQuery(),
    );
    return CustomerCategoriesRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-categories/:id`.
  Future<CustomerCategoryRes> retrieveCategory(
    String categoryId, [
    CustomerCatalogRetrieveParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-categories/$categoryId',
      queryParameters: query?.toQuery(),
    );
    return CustomerCategoryRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-tags`.
  Future<CustomerProductTagsRes> listTags([
    CustomerCatalogListParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-tags',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductTagsRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-tags/:id`.
  Future<CustomerProductTagRes> retrieveTag(
    String tagId, [
    CustomerCatalogRetrieveParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-tags/$tagId',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductTagRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-types`.
  Future<CustomerProductTypesRes> listTypes([
    CustomerCatalogListParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-types',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductTypesRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-types/:id`.
  Future<CustomerProductTypeRes> retrieveType(
    String typeId, [
    CustomerCatalogRetrieveParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-types/$typeId',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductTypeRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-attributes`.
  Future<CustomerProductAttributesRes> listAttributes([
    CustomerCatalogListParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-attributes',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductAttributesRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-attributes/:id`.
  Future<CustomerProductAttributeRes> retrieveAttribute(
    String attributeId, [
    CustomerCatalogRetrieveParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-attributes/$attributeId',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductAttributeRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-options`.
  Future<CustomerProductOptionsRes> listOptions([
    CustomerCatalogListParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-options',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductOptionsRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-options/:id`.
  Future<CustomerProductOptionRes> retrieveOption(
    String optionId, [
    CustomerCatalogRetrieveParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-options/$optionId',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductOptionRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-variants` (needs a sales-channel-scoped key).
  Future<CustomerProductVariantsRes> listVariants([
    CustomerCatalogListParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-variants',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductVariantsRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/product-variants/:id`.
  Future<CustomerProductVariantRes> retrieveVariant(
    String variantId, [
    CustomerCatalogRetrieveParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/product-variants/$variantId',
      queryParameters: query?.toQuery(),
    );
    return CustomerProductVariantRes.fromJson(res.data ?? const {});
  }
}
