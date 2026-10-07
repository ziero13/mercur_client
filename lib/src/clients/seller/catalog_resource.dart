import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Parses a standard `{<key>, count, offset, limit}` envelope.
List<T> parseCatalogList<T>(
  Map<String, dynamic> json,
  String key,
  T Function(Map<String, dynamic>) fromJson,
) {
  final raw = json[key];
  if (raw is! List) return const [];
  return raw
      .whereType<Map<String, dynamic>>()
      .where((m) => (m['id'] ?? m['code']) is String)
      .map(fromJson)
      .toList();
}

int pageInt(Map<String, dynamic> json, String key) =>
    (json[key] as num?)?.toInt() ?? 0;

/// Vendor catalog taxonomy (read-only) + product placement.
class SellerCatalogResource {
  SellerCatalogResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/<domain>` with `limit`/`offset`/`q`.
  Future<({List<T> records, int count})> list<T>(
    String domain,
    String key,
    T Function(Map<String, dynamic>) fromJson, [
    SellerListStockParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/$domain',
      queryParameters: query?.toQuery(),
    );
    final data = res.data ?? const {};
    return (
      records: parseCatalogList(data, key, fromJson),
      count: pageInt(data, 'count'),
    );
  }

  Future<({List<SellerCategory> records, int count})> categories([
    SellerListStockParams? query,
  ]) =>
      list('product-categories', 'product_categories',
          SellerCategory.fromJson, query);

  Future<({List<SellerNamedRef> records, int count})> tags([
    SellerListStockParams? query,
  ]) =>
      list('product-tags', 'product_tags', SellerNamedRef.fromJson, query);

  Future<({List<SellerNamedRef> records, int count})> types([
    SellerListStockParams? query,
  ]) =>
      list('product-types', 'product_types', SellerNamedRef.fromJson, query);

  Future<({List<SellerAttribute> records, int count})> attributes([
    SellerListStockParams? query,
  ]) =>
      list('product-attributes', 'product_attributes',
          SellerAttribute.fromJson, query);

  Future<({List<SellerNamedRef> records, int count})> collections([
    SellerListStockParams? query,
  ]) =>
      list('collections', 'collections', SellerNamedRef.fromJson, query);

  /// `GET /vendor/<domain>/:id` → the entity under its envelope key.
  Future<T> retrieve<T>(
    String domain,
    String id,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final res = await _dio.get<Map<String, dynamic>>('/vendor/$domain/$id');
    return fromJson((res.data ?? const {})[key] as Map<String, dynamic>);
  }

  Future<SellerCategory> retrieveCategory(String id) => retrieve(
      'product-categories', id, 'product_category', SellerCategory.fromJson);

  Future<SellerAttribute> retrieveAttribute(String id) => retrieve(
      'product-attributes', id, 'product_attribute', SellerAttribute.fromJson);

  /// `POST /vendor/product-categories/:id/products`.
  Future<void> assignCategoryProducts(
    String id,
    List<String> productIds,
  ) async {
    await _dio.post<Map<String, dynamic>>(
      '/vendor/product-categories/$id/products',
      data: {
        'product_ids': productIds.map((p) => {'id': p}).toList(),
      },
    );
  }

  /// `POST /vendor/collections/:id/products`.
  Future<void> assignCollectionProducts(
    String id,
    List<String> productIds,
  ) async {
    await _dio.post<Map<String, dynamic>>(
      '/vendor/collections/$id/products',
      data: {
        'product_ids': productIds.map((p) => {'id': p}).toList(),
      },
    );
  }
}

/// Vendor misc reads: regions, currencies, sales channels, store,
/// reasons, customer groups, customers, flags, providers, preferences.
class SellerMiscResource {
  SellerMiscResource(this._dio);

  final Dio _dio;

  Future<({List<SellerRegion> records, int count})> regions([
    SellerListStockParams? query,
  ]) =>
      SellerCatalogResource(_dio)
          .list('regions', 'regions', SellerRegion.fromJson, query);

  Future<SellerRegion> retrieveRegion(String id) =>
      SellerCatalogResource(_dio)
          .retrieve('regions', id, 'region', SellerRegion.fromJson);

  Future<({List<SellerCurrency> records, int count})> currencies([
    SellerListStockParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/currencies',
      queryParameters: query?.toQuery(),
    );
    final data = res.data ?? const {};
    final raw = data['currencies'];
    return (
      records: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['code'] is String)
              .map(SellerCurrency.fromJson)
              .toList()
          : const <SellerCurrency>[],
      count: pageInt(data, 'count'),
    );
  }

  Future<SellerCurrency> retrieveCurrency(String code) async {
    final res = await _dio.get<Map<String, dynamic>>(
        '/vendor/currencies/$code');
    return SellerCurrency.fromJson(
        (res.data ?? const {})['currency'] as Map<String, dynamic>);
  }

  Future<({List<SellerNamedRef> records, int count})> salesChannels([
    SellerListStockParams? query,
  ]) =>
      SellerCatalogResource(_dio).list(
          'sales-channels', 'sales_channels', SellerNamedRef.fromJson, query);

  Future<({List<SellerStore> records, int count})> stores() async {
    final res = await _dio.get<Map<String, dynamic>>('/vendor/stores');
    final data = res.data ?? const {};
    return (
      records: parseCatalogList(data, 'stores', SellerStore.fromJson),
      count: pageInt(data, 'count'),
    );
  }

  Future<({List<SellerNamedRef> records, int count})> refundReasons([
    SellerListStockParams? query,
  ]) =>
      SellerCatalogResource(_dio).list(
          'refund-reasons', 'refund_reasons', SellerNamedRef.fromJson, query);

  Future<({List<SellerNamedRef> records, int count})> returnReasons([
    SellerListStockParams? query,
  ]) =>
      SellerCatalogResource(_dio).list(
          'return-reasons', 'return_reasons', SellerNamedRef.fromJson, query);

  Future<({List<SellerNamedRef> records, int count})> customerGroups([
    SellerListStockParams? query,
  ]) =>
      SellerCatalogResource(_dio).list(
          'customer-groups', 'customer_groups', SellerNamedRef.fromJson, query);

  Future<({List<SellerCustomer> records, int count})> customers([
    SellerListStockParams? query,
  ]) =>
      SellerCatalogResource(_dio)
          .list('customers', 'customers', SellerCustomer.fromJson, query);

  Future<SellerCustomer> retrieveCustomer(String id) =>
      SellerCatalogResource(_dio)
          .retrieve('customers', id, 'customer', SellerCustomer.fromJson);

  /// `GET /vendor/feature-flags` → `{feature_flags: {…}}` object.
  Future<Map<String, bool>> featureFlags() async {
    final res =
        await _dio.get<Map<String, dynamic>>('/vendor/feature-flags');
    final raw =
        (res.data ?? const {})['feature_flags'] as Map<String, dynamic>? ??
            const {};
    return raw.map((k, v) => MapEntry(k, v is bool ? v : false));
  }

  Future<({List<SellerNamedRef> records, int count})>
      fulfillmentProviders([
    SellerListStockParams? query,
  ]) =>
          SellerCatalogResource(_dio).list('fulfillment-providers',
              'fulfillment_providers', SellerNamedRef.fromJson, query);

  Future<({List<SellerPricePreference> records, int count})>
      pricePreferences([
    SellerListStockParams? query,
  ]) =>
          SellerCatalogResource(_dio).list('price-preferences',
              'price_preferences', SellerPricePreference.fromJson, query);
}
