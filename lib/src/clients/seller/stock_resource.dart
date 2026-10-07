import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Vendor inventory, reservations and stock locations.
class SellerStockResource {
  SellerStockResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/inventory-items`.
  Future<SellerInventoryListRes> listItems([
    SellerListStockParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/inventory-items',
      queryParameters: query?.toQuery(),
    );
    return SellerInventoryListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/inventory-items` → `{inventory_item}`.
  Future<SellerInventoryItemRes> createItem(
    SellerInventoryItemReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/inventory-items',
      data: body.toJson(),
    );
    return SellerInventoryItemRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/inventory-items/:id` → `{inventory_item}`.
  Future<SellerInventoryItemRes> retrieveItem(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/inventory-items/$id',
    );
    return SellerInventoryItemRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/inventory-items/:id` → `{inventory_item}`.
  Future<SellerInventoryItemRes> updateItem(
    String id,
    SellerInventoryItemReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/inventory-items/$id',
      data: body.toJson(),
    );
    return SellerInventoryItemRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/inventory-items/:id` → deletion confirmation.
  Future<SellerStockDeleteRes> deleteItem(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/inventory-items/$id',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/inventory-items/:id/location-levels`
  /// (wire key: `inventory_levels`).
  Future<SellerInventoryLevelListRes> listLevels(
    String id, [
    SellerListStockParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/inventory-items/$id/location-levels',
      queryParameters: query?.toQuery(),
    );
    return SellerInventoryLevelListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/inventory-items/:id/location-levels`
  /// → `{inventory_item}`.
  Future<SellerInventoryItemRes> createLevel(
    String id,
    SellerLocationLevelReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/inventory-items/$id/location-levels',
      data: body.toJson(),
    );
    return SellerInventoryItemRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/inventory-items/:id/location-levels/:location_id`
  /// → `{inventory_item}`.
  Future<SellerInventoryItemRes> updateLevel(
    String id,
    String locationId,
    SellerLocationLevelReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/inventory-items/$id/location-levels/$locationId',
      data: body.toJson(),
    );
    return SellerInventoryItemRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/inventory-items/:id/location-levels/:location_id`.
  Future<SellerStockDeleteRes> deleteLevel(
    String id,
    String locationId,
  ) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/inventory-items/$id/location-levels/$locationId',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/inventory-items/location-levels/batch`.
  Future<void> batchLevels(SellerLocationLevelBatchReq body) async {
    await _dio.post<Map<String, dynamic>>(
      '/vendor/inventory-items/location-levels/batch',
      data: body.toJson(),
    );
  }

  /// `GET /vendor/reservations`.
  Future<SellerReservationListRes> listReservations([
    SellerListStockParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/reservations',
      queryParameters: query?.toQuery(),
    );
    return SellerReservationListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/reservations` → `{reservation}`.
  Future<SellerReservationRes> createReservation(
    SellerReservationReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/reservations',
      data: body.toJson(),
    );
    return SellerReservationRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/reservations/:id` → `{reservation}`.
  Future<SellerReservationRes> retrieveReservation(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/reservations/$id',
    );
    return SellerReservationRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/reservations/:id` → `{reservation}`.
  Future<SellerReservationRes> updateReservation(
    String id,
    SellerReservationReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/reservations/$id',
      data: body.toJson(),
    );
    return SellerReservationRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/reservations/:id` → deletion confirmation.
  Future<SellerStockDeleteRes> deleteReservation(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/reservations/$id',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/stock-locations`.
  Future<SellerStockLocationListRes> listLocations([
    SellerListStockParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/stock-locations',
      queryParameters: query?.toQuery(),
    );
    return SellerStockLocationListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/stock-locations` → `{stock_location}`.
  Future<SellerStockLocationRes> createLocation(
    SellerStockLocationReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/stock-locations',
      data: body.toJson(),
    );
    return SellerStockLocationRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/stock-locations/:id` → `{stock_location}`.
  Future<SellerStockLocationRes> retrieveLocation(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/stock-locations/$id',
    );
    return SellerStockLocationRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/stock-locations/:id` → `{stock_location}`.
  Future<SellerStockLocationRes> updateLocation(
    String id,
    SellerStockLocationReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/stock-locations/$id',
      data: body.toJson(),
    );
    return SellerStockLocationRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/stock-locations/:id` → deletion confirmation.
  Future<SellerStockDeleteRes> deleteLocation(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/stock-locations/$id',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/stock-locations/:id/fulfillment-sets`.
  Future<void> createFulfillmentSet(String id) async {
    await _dio.post<Map<String, dynamic>>(
      '/vendor/stock-locations/$id/fulfillment-sets',
    );
  }

  /// `POST /vendor/stock-locations/:id/fulfillment-providers`.
  Future<void> linkFulfillmentProviders(
    String id,
    List<String> providerIds,
  ) async {
    await _dio.post<Map<String, dynamic>>(
      '/vendor/stock-locations/$id/fulfillment-providers',
      data: {
        'provider_ids':
            providerIds.map((p) => {'id': p}).toList(),
      },
    );
  }

  /// `POST /vendor/stock-locations/:id/sales-channels`.
  Future<void> linkSalesChannels(
    String id,
    List<String> salesChannelIds,
  ) async {
    await _dio.post<Map<String, dynamic>>(
      '/vendor/stock-locations/$id/sales-channels',
      data: {
        'sales_channel_ids':
            salesChannelIds.map((s) => {'id': s}).toList(),
      },
    );
  }
}

/// Vendor shipping options, profiles, types and fulfillment sets.
class SellerShippingResource {
  SellerShippingResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/shipping-options`.
  Future<SellerShippingOptionListRes> listOptions([
    SellerListStockParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/shipping-options',
      queryParameters: query?.toQuery(),
    );
    return SellerShippingOptionListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/shipping-options` → `{shipping_option}`.
  Future<SellerShippingOptionRes> createOption(
    SellerShippingOptionReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/shipping-options',
      data: body.toJson(),
    );
    return SellerShippingOptionRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/shipping-options/:id` → `{shipping_option}`.
  Future<SellerShippingOptionRes> retrieveOption(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/shipping-options/$id',
    );
    return SellerShippingOptionRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/shipping-options/:id` → `{shipping_option}`.
  Future<SellerShippingOptionRes> updateOption(
    String id,
    SellerShippingOptionReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/shipping-options/$id',
      data: body.toJson(),
    );
    return SellerShippingOptionRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/shipping-options/:id` → deletion confirmation.
  Future<SellerStockDeleteRes> deleteOption(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/shipping-options/$id',
    );
    return SellerStockDeleteRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/shipping-options/:id/rules/batch`.
  Future<void> batchRules(
    String id,
    SellerShippingRulesBatchReq body,
  ) async {
    await _dio.post<Map<String, dynamic>>(
      '/vendor/shipping-options/$id/rules/batch',
      data: body.toJson(),
    );
  }

  /// `GET /vendor/shipping-option-types`.
  Future<SellerShippingProfileListRes> listOptionTypes([
    SellerListStockParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/shipping-option-types',
      queryParameters: query?.toQuery(),
    );
    return SellerShippingProfileListRes.fromJson(
        res.data ?? const {}, 'shipping_option_types');
  }

  /// `GET /vendor/shipping-profiles`.
  Future<SellerShippingProfileListRes> listProfiles([
    SellerListStockParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/shipping-profiles',
      queryParameters: query?.toQuery(),
    );
    return SellerShippingProfileListRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/shipping-profiles/:id`.
  Future<SellerShippingProfile> retrieveProfile(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/shipping-profiles/$id',
    );
    final data = res.data ?? const {};
    return SellerShippingProfile.fromJson(
        data['shipping_profile'] as Map<String, dynamic>);
  }

  /// `DELETE /vendor/fulfillment-sets/:id`.
  Future<void> deleteFulfillmentSet(String id) async {
    await _dio.delete<Map<String, dynamic>>(
      '/vendor/fulfillment-sets/$id',
    );
  }

  /// `POST /vendor/fulfillment-sets/:id/service-zones`.
  Future<void> createServiceZone(
    String id,
    SellerServiceZoneReq body,
  ) async {
    await _dio.post<Map<String, dynamic>>(
      '/vendor/fulfillment-sets/$id/service-zones',
      data: body.toJson(),
    );
  }
}
