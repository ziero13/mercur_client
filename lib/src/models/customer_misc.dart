// Store misc reads: currencies, locales, payment providers
// (`GET /store/*`, read-only).
//
// Only `id`/`code` is required everywhere — partial `fields` selections
// fall back to neutral defaults (see AGENTS.md).

/// Store currency.
class CustomerCurrency {
  const CustomerCurrency({
    required this.code,
    this.name,
    this.symbol,
    this.decimalDigits,
  });

  final String code;
  final String? name;
  final String? symbol;
  final int? decimalDigits;

  factory CustomerCurrency.fromJson(Map<String, dynamic> json) {
    return CustomerCurrency(
      code: json['code'] as String,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      decimalDigits: (json['decimal_digits'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (decimalDigits != null) 'decimal_digits': decimalDigits,
    };
  }
}

/// Store locale (`GET /store/locales`).
///
/// NOTE: served only when the backend `translation` feature flag is on —
/// otherwise the route 404s. Modelled tolerantly for re-probe then.
class CustomerLocale {
  const CustomerLocale({
    required this.code,
    this.name,
  });

  final String code;
  final String? name;

  factory CustomerLocale.fromJson(Map<String, dynamic> json) {
    return CustomerLocale(
      code: json['code'] as String,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      if (name != null) 'name': name,
    };
  }
}

/// Store payment provider (`GET /store/payment-providers?region_id=`).
class CustomerPaymentProvider {
  const CustomerPaymentProvider({
    required this.id,
    this.isEnabled,
  });

  final String id;
  final bool? isEnabled;

  factory CustomerPaymentProvider.fromJson(Map<String, dynamic> json) {
    return CustomerPaymentProvider(
      id: json['id'] as String,
      isEnabled: json['is_enabled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (isEnabled != null) 'is_enabled': isEnabled,
    };
  }
}
