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

/// Store region country row (`GET /store/regions*` → `countries[]`).
///
/// Wire fields verified live against the backend: `iso_2`, `iso_3`,
/// `num_code`, `name`, `display_name`, `region_id`. Only `iso_2` is
/// required — partial `fields` selections fall back to null.
class CustomerCountry {
  const CustomerCountry({
    required this.iso2,
    this.iso3,
    this.numCode,
    this.name,
    this.displayName,
    this.regionId,
  });

  final String iso2;
  final String? iso3;
  final String? numCode;
  final String? name;
  final String? displayName;
  final String? regionId;

  factory CustomerCountry.fromJson(Map<String, dynamic> json) {
    return CustomerCountry(
      iso2: json['iso_2'] as String,
      iso3: json['iso_3'] as String?,
      numCode: json['num_code'] as String?,
      name: json['name'] as String?,
      displayName: json['display_name'] as String?,
      regionId: json['region_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iso_2': iso2,
      if (iso3 != null) 'iso_3': iso3,
      if (numCode != null) 'num_code': numCode,
      if (name != null) 'name': name,
      if (displayName != null) 'display_name': displayName,
      if (regionId != null) 'region_id': regionId,
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
