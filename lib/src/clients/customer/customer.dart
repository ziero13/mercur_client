import 'package:dio/dio.dart';

import '../../models/models.dart';
import '../auth_sink.dart';
import 'auth_resource.dart';
import 'carts_resource.dart';
import 'offers_resource.dart';
import 'products_resource.dart';
import 'sellers_resource.dart';

/// Customer entry point — the `/store/*` surface (storefront buyer).
class CustomerClient {
  CustomerClient(Dio dio, {AuthTokenSink? onCustomerToken})
      : products = CustomerProductsResource(dio),
        sellers = CustomerSellersResource(dio),
        offers = CustomerOffersResource(dio),
        carts = CustomerCartsResource(dio),
        auth = CustomerAuthResource(dio, onCustomerToken: onCustomerToken);

  final CustomerProductsResource products;
  final CustomerSellersResource sellers;
  final CustomerOffersResource offers;
  final CustomerCartsResource carts;
  final CustomerAuthResource auth;

  /// 3-step registration as one call (register → create → login).
  Future<CustomerRegistrationRes> registerCustomer(
    RegisterCustomerReq body,
  ) =>
      auth.registerCustomer(body);
}
