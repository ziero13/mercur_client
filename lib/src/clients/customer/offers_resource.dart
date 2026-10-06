import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store offers (`GET /store/offers`, `GET /store/offers/:id`) with
/// per-offer calculated prices when a pricing context resolves.
class CustomerOffersResource {
  CustomerOffersResource(this._dio);

  final Dio _dio;

  Future<CustomerOfferListRes> list([
    CustomerListOffersParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/offers',
      queryParameters: query?.toQuery(),
    );
    return CustomerOfferListRes.fromJson(res.data ?? const {});
  }

  Future<CustomerOfferRes> retrieve(
    String id, [
    CustomerRetrieveOfferParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/offers/$id',
      queryParameters: query?.toQuery(),
    );
    return CustomerOfferRes.fromJson(res.data ?? const {});
  }
}
