/// Typed Store headers. Carried by [StoreAuthInterceptor] in practice;
/// this class exists for call sites that must build headers explicitly
/// (tests, custom Dio wiring). Serialised at the Dio boundary only.
class StoreHeaders {
  const StoreHeaders({required this.publishableKey, this.customerToken});

  final String publishableKey;
  final String? customerToken;

  Map<String, String> toHeaders() {
    return {
      'x-publishable-api-key': publishableKey,
      if (customerToken != null && customerToken!.isNotEmpty)
        'Authorization': 'Bearer $customerToken',
    };
  }

  factory StoreHeaders.fromJson(Map<String, dynamic> json) {
    return StoreHeaders(
      publishableKey: json['x-publishable-api-key'] as String? ?? '',
      customerToken: (json['Authorization'] as String?)?.replaceFirst(
        RegExp(r'^Bearer\s+'),
        '',
      ),
    );
  }

  Map<String, dynamic> toJson() => toHeaders();
}

/// Typed Vendor headers: member Bearer + `x-seller-id` scoping.
class SellerHeaders {
  const SellerHeaders({this.memberToken, this.sellerId});

  final String? memberToken;
  final String? sellerId;

  Map<String, String> toHeaders() {
    return {
      if (memberToken != null && memberToken!.isNotEmpty)
        'Authorization': 'Bearer $memberToken',
      if (sellerId != null && sellerId!.isNotEmpty) 'x-seller-id': sellerId!,
    };
  }

  factory SellerHeaders.fromJson(Map<String, dynamic> json) {
    return SellerHeaders(
      memberToken: (json['Authorization'] as String?)?.replaceFirst(
        RegExp(r'^Bearer\s+'),
        '',
      ),
      sellerId: json['x-seller-id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => toHeaders();
}

/// Typed Admin headers: operator Bearer.
class AdminHeaders {
  const AdminHeaders({this.userToken});

  final String? userToken;

  Map<String, String> toHeaders() {
    return {
      if (userToken != null && userToken!.isNotEmpty)
        'Authorization': 'Bearer $userToken',
    };
  }

  factory AdminHeaders.fromJson(Map<String, dynamic> json) {
    return AdminHeaders(
      userToken: (json['Authorization'] as String?)?.replaceFirst(
        RegExp(r'^Bearer\s+'),
        '',
      ),
    );
  }

  Map<String, dynamic> toJson() => toHeaders();
}
