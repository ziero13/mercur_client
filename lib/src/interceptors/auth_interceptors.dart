import 'package:dio/dio.dart';

/// Injects Store auth headers on every `/store/*` request:
/// always `x-publishable-api-key`, plus `Authorization: Bearer`
/// when a customer token is set (logged-in customer enriches pricing).
class StoreAuthInterceptor extends Interceptor {
  StoreAuthInterceptor({required this.publishableKey, this.customerToken});

  String publishableKey;
  String? customerToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-publishable-api-key'] = publishableKey;
    final token = customerToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Injects Vendor auth: member Bearer plus `x-seller-id` scoping.
class SellerScopeInterceptor extends Interceptor {
  SellerScopeInterceptor({this.memberToken, this.sellerId});

  String? memberToken;
  String? sellerId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = memberToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final scope = sellerId;
    if (scope != null && scope.isNotEmpty) {
      options.headers['x-seller-id'] = scope;
    }
    handler.next(options);
  }
}

/// Injects Admin auth: operator Bearer.
class AdminAuthInterceptor extends Interceptor {
  AdminAuthInterceptor({this.userToken});

  String? userToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = userToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
