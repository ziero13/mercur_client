import 'package:dio/dio.dart';

import 'clients/clients.dart';
import 'configuration.dart';
import 'interceptors/interceptors.dart';

export 'api_error.dart';
export 'configuration.dart';

/// Root client — builds the 3 surface Dio instances and exposes the
/// `customer` / `seller` / `admin` entry points.
///
/// - customer (`/store/*`): always `x-publishable-api-key`, optional
///   customer Bearer (set via [setCustomerToken]).
/// - seller (`/vendor/*`): member Bearer + `x-seller-id` scoping
///   (set via [setMemberToken] / [setSellerId]).
/// - admin (`/admin/*`): operator Bearer (set via [setUserToken]).
class Mercur {
  Mercur(this.configuration) {
    _storeAuth = StoreAuthInterceptor(
      publishableKey: configuration.publishableKey,
    );
    _sellerScope = SellerScopeInterceptor();
    _adminAuth = AdminAuthInterceptor();

    customerDio = _buildDio([_storeAuth, ErrorInterceptor()]);
    sellerDio = _buildDio([_sellerScope, ErrorInterceptor()]);
    adminDio = _buildDio([_adminAuth, ErrorInterceptor()]);

    customer = CustomerClient(
      customerDio,
      onCustomerToken: setCustomerToken,
    );
    seller = SellerClient(
      sellerDio,
      onMemberToken: setMemberToken,
      onSellerSelected: setSellerId,
    );
    admin = AdminClient(adminDio, onUserToken: setUserToken);
  }

  final Configuration configuration;

  late final Dio customerDio;
  late final Dio sellerDio;
  late final Dio adminDio;

  late final CustomerClient customer;
  late final SellerClient seller;
  late final AdminClient admin;

  late final StoreAuthInterceptor _storeAuth;
  late final SellerScopeInterceptor _sellerScope;
  late final AdminAuthInterceptor _adminAuth;

  Dio _buildDio(List<Interceptor> interceptors) {
    final dio = Dio(
      BaseOptions(
        baseUrl: configuration.baseUrl,
        connectTimeout: configuration.connectTimeout,
        receiveTimeout: configuration.receiveTimeout,
        headers: const {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.addAll(interceptors);
    return dio;
  }

  /// Logged-in customer JWT (enriches Store pricing context).
  void setCustomerToken(String? token) => _storeAuth.customerToken = token;

  /// Seller member JWT (Vendor surface).
  void setMemberToken(String? token) => _sellerScope.memberToken = token;

  /// Active seller scope for the Vendor surface.
  void setSellerId(String? sellerId) => _sellerScope.sellerId = sellerId;

  /// Operator JWT (Admin surface).
  void setUserToken(String? token) => _adminAuth.userToken = token;

  /// Clears all bearer tokens and the seller scope.
  void clearAuth() {
    setCustomerToken(null);
    setMemberToken(null);
    setSellerId(null);
    setUserToken(null);
  }
}
