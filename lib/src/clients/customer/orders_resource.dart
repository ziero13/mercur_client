import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Store orders: list + retrieve (customer Bearer) plus the ownership
/// transfer flow (request / cancel / accept / decline).
class CustomerOrdersResource {
  CustomerOrdersResource(this._dio);

  final Dio _dio;

  /// `GET /store/orders`.
  Future<CustomerOrdersRes> list([CustomerListOrdersParams? query]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/orders',
      queryParameters: query?.toQuery(),
    );
    return CustomerOrdersRes.fromJson(res.data ?? const {});
  }

  /// `GET /store/orders/:id`.
  Future<CustomerOrderRes> retrieve(
    String orderId, [
    CustomerRetrieveOrderParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/store/orders/$orderId',
      queryParameters: query?.toQuery(),
    );
    return CustomerOrderRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/orders/:id/transfer/request`.
  Future<CustomerOrderRes> requestTransfer(
    String orderId, [
    CustomerRequestOrderTransferReq? body,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/orders/$orderId/transfer/request',
      data: (body ?? const CustomerRequestOrderTransferReq()).toJson(),
    );
    return CustomerOrderRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/orders/:id/transfer/cancel`.
  Future<CustomerOrderRes> cancelTransfer(String orderId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/orders/$orderId/transfer/cancel',
      data: const {},
    );
    return CustomerOrderRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/orders/:id/transfer/accept`.
  Future<CustomerOrderRes> acceptTransfer(
    String orderId,
    CustomerAcceptOrderTransferReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/orders/$orderId/transfer/accept',
      data: body.toJson(),
    );
    return CustomerOrderRes.fromJson(res.data ?? const {});
  }

  /// `POST /store/orders/:id/transfer/decline`.
  Future<CustomerOrderRes> declineTransfer(
    String orderId,
    CustomerDeclineOrderTransferReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/store/orders/$orderId/transfer/decline',
      data: body.toJson(),
    );
    return CustomerOrderRes.fromJson(res.data ?? const {});
  }
}
