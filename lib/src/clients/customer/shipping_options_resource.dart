import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store shipping options: list grouped by seller, calculate one option.
class CustomerShippingOptionsResource {
  CustomerShippingOptionsResource(this._dio);

  final Dio _dio;

  /// `GET /store/shipping-options` — options grouped by seller id.
  Future<CustomerShippingOptionsRes> list(
    CustomerListShippingOptionsParams query,
  ) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/shipping-options',
      queryParameters: query.toQuery(),
    );
    return CustomerShippingOptionsRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/shipping-options/:id/calculate`.
  Future<CustomerShippingOptionRes> calculate(
    String optionId,
    CustomerCalculateShippingOptionReq body, [
    CustomerRetrieveCartParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/shipping-options/$optionId/calculate',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return CustomerShippingOptionRes.fromJson(res.data ?? const {});
  }
}
