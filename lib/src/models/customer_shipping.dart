/// Store shipping option (flat row inside the seller-grouped map from
/// `GET /store/shipping-options`, or `POST …/:id/calculate`).
///
/// Only `id` is required — partial `fields` selections fall back to
/// neutral defaults (see AGENTS.md).
class CustomerShippingOption {
  const CustomerShippingOption({
    required this.id,
    this.name,
    this.priceType,
    this.providerId,
    this.amount,
    this.typeCode,
    this.typeLabel,
  });

  final String id;
  final String? name;
  final String? priceType;
  final String? providerId;
  final int? amount;
  final String? typeCode;
  final String? typeLabel;

  factory CustomerShippingOption.fromJson(Map<String, dynamic> json) {
    int? toInt(Object? raw) => (raw as num?)?.toInt();
    final rawType = json['type'];
    return CustomerShippingOption(
      id: json['id'] as String,
      name: json['name'] as String?,
      priceType: json['price_type'] as String?,
      providerId: json['provider_id'] as String?,
      amount: toInt(json['amount']),
      typeCode: rawType is Map<String, dynamic>
          ? rawType['code'] as String?
          : null,
      typeLabel: rawType is Map<String, dynamic>
          ? rawType['label'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (priceType != null) 'price_type': priceType,
      if (providerId != null) 'provider_id': providerId,
      if (amount != null) 'amount': amount,
      if (typeCode != null || typeLabel != null)
        'type': {
          if (typeCode != null) 'code': typeCode,
          if (typeLabel != null) 'label': typeLabel,
        },
    };
  }
}

/// Store region country row.
class CustomerCountry {
  const CustomerCountry({
    required this.iso2,
    this.displayName,
  });

  final String iso2;
  final String? displayName;

  factory CustomerCountry.fromJson(Map<String, dynamic> json) {
    return CustomerCountry(
      iso2: json['iso_2'] as String,
      displayName: json['display_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iso_2': iso2,
      if (displayName != null) 'display_name': displayName,
    };
  }
}

/// Store region (`GET /store/regions*`).
///
/// Only `id` is required — partial `fields` selections fall back to
/// neutral defaults (see AGENTS.md).
class CustomerRegion {
  const CustomerRegion({
    required this.id,
    this.name,
    this.currencyCode,
    this.countries = const [],
  });

  final String id;
  final String? name;
  final String? currencyCode;
  final List<CustomerCountry> countries;

  factory CustomerRegion.fromJson(Map<String, dynamic> json) {
    final rawCountries = json['countries'];
    return CustomerRegion(
      id: json['id'] as String,
      name: json['name'] as String?,
      currencyCode: json['currency_code'] as String?,
      countries: rawCountries is List
          ? rawCountries
              .whereType<Map<String, dynamic>>()
              .where((m) => m['iso_2'] is String)
              .map(CustomerCountry.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (currencyCode != null) 'currency_code': currencyCode,
      'countries': countries.map((c) => c.toJson()).toList(),
    };
  }
}
