import 'package:dio/dio.dart';

import '../../models/models.dart';
import '../auth_sink.dart';

/// Store auth: customer login + 3-step registration.
///
/// `POST /store/customers` is anonymous-401 by design — registration
/// always carries the unregistered-identity Bearer from the register
/// step (verified live against the local backend).
class CustomerAuthResource {
  CustomerAuthResource(this._dio, {this.onCustomerToken});

  final Dio _dio;
  final AuthTokenSink? onCustomerToken;

  /// `POST /auth/customer/emailpass` → installs the customer token.
  Future<TokenRes> login(LoginReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/customer/emailpass',
      data: body.toJson(),
    );
    final token = TokenRes.fromJson(res.data ?? const {});
    onCustomerToken?.call(token.token);
    return token;
  }

  /// Registration as a single call: register → create customer → login.
  ///
  /// Requires no active customer session (the backend rejects register
  /// while authenticated) — use a fresh [Mercur] or `clearAuth()` first.
  /// On success the new token is installed on the customer Dio.
  Future<CustomerRegistrationRes> registerCustomer(
    RegisterCustomerReq body,
  ) async {
    final registerRes = await _dio.post<Map<String, dynamic>>(
      '/auth/customer/emailpass/register',
      data: {'email': body.email, 'password': body.password},
    );
    final preToken = TokenRes.fromJson(registerRes.data ?? const {}).token;

    final customerRes = await _dio.post<Map<String, dynamic>>(
      '/store/customers',
      data: CustomerCreateReq(
        email: body.email,
        firstName: body.firstName,
        lastName: body.lastName,
        phone: body.phone,
        companyName: body.companyName,
      ).toJson(),
      options: Options(headers: {'Authorization': 'Bearer $preToken'}),
    );
    final customer =
        CustomerRes.fromJson(customerRes.data ?? const {}).customer;

    final token = await login(
      LoginReq(email: body.email, password: body.password),
    );
    return CustomerRegistrationRes(customer: customer, token: token.token);
  }
}
