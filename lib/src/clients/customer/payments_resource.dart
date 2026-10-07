import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store payment collections (`POST /store/payment-collections`,
/// `POST /store/payment-collections/:id/payment-sessions`) — the checkout
/// payment step: collection per cart, then one session per provider.
class CustomerPaymentsResource {
  CustomerPaymentsResource(this._dio);

  final Dio _dio;

  /// Create (or return the existing) payment collection for [body.cartId].
  Future<CustomerPaymentCollectionRes> createCollection(
    CustomerCreatePaymentCollectionReq body, [
    CustomerPaymentCollectionParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/payment-collections',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return CustomerPaymentCollectionRes.fromJson(res.data ?? const {});
  }

  /// Initialize a payment session for [providerId] on a collection.
  Future<CustomerPaymentCollectionRes> createSession(
    String collectionId,
    CustomerCreatePaymentSessionReq body, [
    CustomerPaymentCollectionParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/payment-collections/$collectionId/payment-sessions',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return CustomerPaymentCollectionRes.fromJson(res.data ?? const {});
  }
}
