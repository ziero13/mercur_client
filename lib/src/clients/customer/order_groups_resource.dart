import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store order groups (`GET /store/order-groups`,
/// `GET /store/order-groups/:id`).
///
/// Customer JWT required on both; results are scoped to the
/// authenticated customer. The list query always sends explicit
/// `fields` (omitting them fails 400 on the relation-expansion cap).
class CustomerOrderGroupsResource {
  CustomerOrderGroupsResource(this._dio);

  final Dio _dio;

  Future<CustomerOrderGroupListRes> list([
    CustomerListOrderGroupsParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/order-groups',
      queryParameters:
          (query ?? const CustomerListOrderGroupsParams()).toQuery(),
    );
    return CustomerOrderGroupListRes.fromJson(res.data ?? const {});
  }

  Future<CustomerOrderGroupRes> retrieve(
    String id, [
    CustomerRetrieveOrderGroupParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/order-groups/$id',
      queryParameters:
          (query ?? const CustomerRetrieveOrderGroupParams()).toQuery(),
    );
    return CustomerOrderGroupRes.fromJson(res.data ?? const {});
  }
}
