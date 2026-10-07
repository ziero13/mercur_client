import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store misc reads (all read-only): currencies, locales, payment
/// provider listing (collections/sessions stay out of scope).
class CustomerMiscResource {
  CustomerMiscResource(this._dio);

  final Dio _dio;

  /// `GET /store/currencies`.
  Future<CustomerCurrenciesRes> listCurrencies([
    CustomerListCurrenciesParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/currencies',
      queryParameters: query?.toQuery(),
    );
    return CustomerCurrenciesRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/currencies/:code`.
  Future<CustomerCurrencyRes> retrieveCurrency(
    String code, [
    CustomerRetrieveCurrencyParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/currencies/$code',
      queryParameters: query?.toQuery(),
    );
    return CustomerCurrencyRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/locales` — 404 unless the backend `translation`
  /// feature flag is enabled.
  Future<CustomerLocalesRes> listLocales() async {
    final res = await _dio.get<Map<String, dynamic>>('/store/locales');
    return CustomerLocalesRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/payment-providers` (`region_id` required).
  Future<CustomerPaymentProvidersRes> listPaymentProviders(
    CustomerListPaymentProvidersParams query,
  ) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/payment-providers',
      queryParameters: query.toQuery(),
    );
    return CustomerPaymentProvidersRes.fromJson(res.data ?? const {});
  }
}
