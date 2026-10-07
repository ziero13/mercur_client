import '../customer_misc.dart';

/// Response of `GET /store/currencies`.
class CustomerCurrenciesRes {
  const CustomerCurrenciesRes({
    required this.currencies,
    required this.count,
    this.offset,
    this.limit,
  });

  final List<CustomerCurrency> currencies;
  final int count;
  final int? offset;
  final int? limit;

  factory CustomerCurrenciesRes.fromJson(Map<String, dynamic> json) {
    final raw = json['currencies'];
    return CustomerCurrenciesRes(
      currencies: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['code'] is String)
              .map(CustomerCurrency.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencies': currencies.map((c) => c.toJson()).toList(),
      'count': count,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };
  }
}

/// Response of `GET /store/currencies/:code`.
class CustomerCurrencyRes {
  const CustomerCurrencyRes({required this.currency});

  final CustomerCurrency currency;

  factory CustomerCurrencyRes.fromJson(Map<String, dynamic> json) {
    return CustomerCurrencyRes(
      currency: CustomerCurrency.fromJson(
        json['currency'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {'currency': currency.toJson()};
}

/// Response of `GET /store/locales`.
class CustomerLocalesRes {
  const CustomerLocalesRes({required this.locales});

  final List<CustomerLocale> locales;

  factory CustomerLocalesRes.fromJson(Map<String, dynamic> json) {
    final raw = json['locales'];
    return CustomerLocalesRes(
      locales: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['code'] is String)
              .map(CustomerLocale.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'locales': locales.map((l) => l.toJson()).toList()};
  }
}

/// Response of `GET /store/payment-providers`.
class CustomerPaymentProvidersRes {
  const CustomerPaymentProvidersRes({
    required this.paymentProviders,
    required this.count,
    this.offset,
    this.limit,
  });

  final List<CustomerPaymentProvider> paymentProviders;
  final int count;
  final int? offset;
  final int? limit;

  factory CustomerPaymentProvidersRes.fromJson(Map<String, dynamic> json) {
    final raw = json['payment_providers'];
    return CustomerPaymentProvidersRes(
      paymentProviders: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerPaymentProvider.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_providers':
          paymentProviders.map((p) => p.toJson()).toList(),
      'count': count,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };
  }
}
