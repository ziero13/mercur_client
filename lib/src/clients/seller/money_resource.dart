import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Vendor payments (`/vendor/payments*`).
///
/// Capture/refund move real money — only call them for payments the
/// seller actually wants to settle.
class SellerPaymentsResource {
  SellerPaymentsResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/payments`.
  Future<SellerPaymentListRes> list([SellerListMoneyParams? query]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/payments',
      queryParameters: query?.toQuery(),
    );
    return SellerPaymentListRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/payments/:id` → `{payment}`.
  Future<SellerPaymentRes> retrieve(String id) async {
    final res = await _dio.get<Map<String, dynamic>>('/vendor/payments/$id');
    return SellerPaymentRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/payments/:id/capture` → `{payment}`.
  Future<SellerPaymentRes> capture(
    String id, [
    SellerCapturePaymentReq? body,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/payments/$id/capture',
      data: body?.toJson(),
    );
    return SellerPaymentRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/payments/:id/refund` → `{payment}`.
  Future<SellerPaymentRes> refund(
    String id, [
    SellerRefundPaymentReq? body,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/payments/$id/refund',
      data: body?.toJson(),
    );
    return SellerPaymentRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/payments/payment-providers`.
  Future<SellerPaymentProviderListRes> providers() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/payments/payment-providers',
    );
    return SellerPaymentProviderListRes.fromJson(res.data ?? const {});
  }
}

/// Vendor payouts + payout accounts (`/vendor/payouts*`,
/// `/vendor/payout-accounts*`).
class SellerPayoutsResource {
  SellerPayoutsResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/payouts`.
  Future<SellerPayoutListRes> list([SellerListMoneyParams? query]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/payouts',
      queryParameters: query?.toQuery(),
    );
    return SellerPayoutListRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/payouts/:id` → `{payout}`.
  Future<SellerPayoutRes> retrieve(String id) async {
    final res = await _dio.get<Map<String, dynamic>>('/vendor/payouts/$id');
    return SellerPayoutRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/payout-accounts`.
  Future<SellerPayoutAccountListRes> accounts([
    SellerListMoneyParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/payout-accounts',
      queryParameters: query?.toQuery(),
    );
    return SellerPayoutAccountListRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/payout-accounts/:id` → `{payout_account}`.
  Future<SellerPayoutAccountRes> retrieveAccount(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/payout-accounts/$id',
    );
    return SellerPayoutAccountRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/payout-accounts` → `{payout_account}`.
  Future<SellerPayoutAccountRes> createAccount(
    SellerCreatePayoutAccountReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/payout-accounts',
      data: body.toJson(),
    );
    return SellerPayoutAccountRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/payout-accounts/:id/onboarding` → `{onboarding}`.
  Future<SellerOnboardingRes> onboard(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/payout-accounts/$id/onboarding',
    );
    return SellerOnboardingRes.fromJson(res.data ?? const {});
  }
}
