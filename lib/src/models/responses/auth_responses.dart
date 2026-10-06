import '../customer.dart';

/// `{token}` returned by every `/auth/*` login/register endpoint.
class TokenRes {
  const TokenRes({required this.token});

  final String token;

  factory TokenRes.fromJson(Map<String, dynamic> json) {
    return TokenRes(token: json['token'] as String);
  }

  Map<String, dynamic> toJson() => {'token': token};
}

/// Response wrapping a customer (`POST /store/customers`).
class CustomerRes {
  const CustomerRes({required this.customer});

  final Customer customer;

  factory CustomerRes.fromJson(Map<String, dynamic> json) {
    return CustomerRes(
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'customer': customer.toJson()};
}

/// Result of [CustomerAuthResource.registerCustomer]: the created
/// customer plus its authenticated token (also installed on the
/// customer Dio, so follow-up calls are authenticated).
class CustomerRegistrationRes {
  const CustomerRegistrationRes({required this.customer, required this.token});

  final Customer customer;
  final String token;

  factory CustomerRegistrationRes.fromJson(Map<String, dynamic> json) {
    return CustomerRegistrationRes(
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'customer': customer.toJson(), 'token': token};
  }
}
