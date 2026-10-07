// Catalog taxonomy + misc read entities (all `{id, …}`, lists only).
// Only `id` is required everywhere.

// Generic named ref (`id` + optional `name`/`handle`).
class SellerNamedRef {
  const SellerNamedRef({required this.id, this.name, this.handle});

  final String id;
  final String? name;
  final String? handle;

  factory SellerNamedRef.fromJson(Map<String, dynamic> json) {
    return SellerNamedRef(
      id: json['id'] as String,
      name: (json['name'] ?? json['label'] ?? json['title']) as String?,
      handle: json['handle'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (handle != null) 'handle': handle,
    };
  }
}

/// Product category (`product_categories`).
class SellerCategory {
  const SellerCategory({
    required this.id,
    this.name = '',
    this.handle = '',
    this.description,
    this.isActive,
    this.parentCategoryId,
  });

  final String id;
  final String name;
  final String handle;
  final String? description;
  final bool? isActive;
  final String? parentCategoryId;

  factory SellerCategory.fromJson(Map<String, dynamic> json) {
    return SellerCategory(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool?,
      parentCategoryId: json['parent_category_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (parentCategoryId != null) 'parent_category_id': parentCategoryId,
    };
  }
}

/// Product attribute definition (`product_attributes`).
class SellerAttribute {
  const SellerAttribute({
    required this.id,
    this.name = '',
    this.handle = '',
    this.type,
    this.isVariantAxis,
    this.isFilterable,
    this.isRequired,
  });

  final String id;
  final String name;
  final String handle;
  final String? type;
  final bool? isVariantAxis;
  final bool? isFilterable;
  final bool? isRequired;

  factory SellerAttribute.fromJson(Map<String, dynamic> json) {
    return SellerAttribute(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      type: json['type'] as String?,
      isVariantAxis: json['is_variant_axis'] as bool?,
      isFilterable: json['is_filterable'] as bool?,
      isRequired: json['is_required'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      if (type != null) 'type': type,
      if (isVariantAxis != null) 'is_variant_axis': isVariantAxis,
      if (isFilterable != null) 'is_filterable': isFilterable,
      if (isRequired != null) 'is_required': isRequired,
    };
  }
}

/// Region (`regions`, with embedded countries on detail).
class SellerRegion {
  const SellerRegion({
    required this.id,
    this.name = '',
    this.currencyCode,
    this.automaticTaxes,
  });

  final String id;
  final String name;
  final String? currencyCode;
  final bool? automaticTaxes;

  factory SellerRegion.fromJson(Map<String, dynamic> json) {
    return SellerRegion(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      currencyCode: json['currency_code'] as String?,
      automaticTaxes: json['automatic_taxes'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (automaticTaxes != null) 'automatic_taxes': automaticTaxes,
    };
  }
}

/// Currency (`currencies`, keyed by `code`).
class SellerCurrency {
  const SellerCurrency({required this.code, this.name, this.symbol});

  final String code;
  final String? name;
  final String? symbol;

  factory SellerCurrency.fromJson(Map<String, dynamic> json) {
    return SellerCurrency(
      code: json['code'] as String,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
    };
  }
}

/// Store (`stores`).
class SellerStore {
  const SellerStore({
    required this.id,
    this.name = '',
    this.defaultSalesChannelId,
    this.defaultRegionId,
    this.defaultLocationId,
  });

  final String id;
  final String name;
  final String? defaultSalesChannelId;
  final String? defaultRegionId;
  final String? defaultLocationId;

  factory SellerStore.fromJson(Map<String, dynamic> json) {
    return SellerStore(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      defaultSalesChannelId: json['default_sales_channel_id'] as String?,
      defaultRegionId: json['default_region_id'] as String?,
      defaultLocationId: json['default_location_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (defaultSalesChannelId != null)
        'default_sales_channel_id': defaultSalesChannelId,
      if (defaultRegionId != null) 'default_region_id': defaultRegionId,
      if (defaultLocationId != null)
        'default_location_id': defaultLocationId,
    };
  }
}

/// Vendor-visible customer (`customers`).
class SellerCustomer {
  const SellerCustomer({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  final String id;
  final String? email;
  final String? firstName;
  final String? lastName;

  factory SellerCustomer.fromJson(Map<String, dynamic> json) {
    return SellerCustomer(
      id: json['id'] as String,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
    };
  }
}

/// Price preference (`price_preferences`).
class SellerPricePreference {
  const SellerPricePreference({
    required this.id,
    this.attribute,
    this.value,
    this.isTaxInclusive,
  });

  final String id;
  final String? attribute;
  final String? value;
  final bool? isTaxInclusive;

  factory SellerPricePreference.fromJson(Map<String, dynamic> json) {
    return SellerPricePreference(
      id: json['id'] as String,
      attribute: json['attribute'] as String?,
      value: json['value'] as String?,
      isTaxInclusive: json['is_tax_inclusive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (attribute != null) 'attribute': attribute,
      if (value != null) 'value': value,
      if (isTaxInclusive != null) 'is_tax_inclusive': isTaxInclusive,
    };
  }
}
