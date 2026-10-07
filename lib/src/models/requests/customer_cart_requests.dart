/// Body of `POST /store/carts` (Medusa core create).
class CustomerCreateCartReq {
  const CustomerCreateCartReq({
    required this.regionId,
    this.email,
    this.countryCode,
    this.salesChannelId,
  });

  final String regionId;
  final String? email;
  final String? countryCode;
  final String? salesChannelId;

  Map<String, dynamic> toJson() {
    return {
      'region_id': regionId,
      if (email != null) 'email': email,
      if (countryCode != null) 'country_code': countryCode,
      if (salesChannelId != null) 'sales_channel_id': salesChannelId,
    };
  }

  factory CustomerCreateCartReq.fromJson(Map<String, dynamic> json) {
    return CustomerCreateCartReq(
      regionId: json['region_id'] as String,
      email: json['email'] as String?,
      countryCode: json['country_code'] as String?,
      salesChannelId: json['sales_channel_id'] as String?,
    );
  }
}

/// Body of `POST /store/carts/:id/line-items`.
///
/// Mercur takes an [offerId] — never a `variant_id` (verified quirk).
class CustomerAddLineItemReq {
  const CustomerAddLineItemReq({
    required this.offerId,
    required this.quantity,
    this.unitPrice,
    this.compareAtUnitPrice,
  });

  final String offerId;
  final int quantity;
  final int? unitPrice;
  final int? compareAtUnitPrice;

  Map<String, dynamic> toJson() {
    return {
      'offer_id': offerId,
      'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (compareAtUnitPrice != null)
        'compare_at_unit_price': compareAtUnitPrice,
    };
  }

  factory CustomerAddLineItemReq.fromJson(Map<String, dynamic> json) {
    return CustomerAddLineItemReq(
      offerId: json['offer_id'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toInt(),
      compareAtUnitPrice:
          (json['compare_at_unit_price'] as num?)?.toInt(),
    );
  }
}

/// Upsert cart address (`shipping_address` / `billing_address` on
/// `POST /store/carts/:id`). An `id` references a saved address,
/// otherwise the fields below form the address payload.
class CustomerCartAddressReq {
  const CustomerCartAddressReq({
    this.id,
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.city,
    this.countryCode,
    this.province,
    this.postalCode,
    this.phone,
    this.company,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? address1;
  final String? address2;
  final String? city;
  final String? countryCode;
  final String? province;
  final String? postalCode;
  final String? phone;
  final String? company;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (address1 != null) 'address_1': address1,
      if (address2 != null) 'address_2': address2,
      if (city != null) 'city': city,
      if (countryCode != null) 'country_code': countryCode,
      if (province != null) 'province': province,
      if (postalCode != null) 'postal_code': postalCode,
      if (phone != null) 'phone': phone,
      if (company != null) 'company': company,
    };
  }

  factory CustomerCartAddressReq.fromJson(Map<String, dynamic> json) {
    return CustomerCartAddressReq(
      id: json['id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      address1: json['address_1'] as String?,
      address2: json['address_2'] as String?,
      city: json['city'] as String?,
      countryCode: json['country_code'] as String?,
      province: json['province'] as String?,
      postalCode: json['postal_code'] as String?,
      phone: json['phone'] as String?,
      company: json['company'] as String?,
    );
  }
}

/// Body of `POST /store/carts/:id` (update email, region, addresses…).
class CustomerUpdateCartReq {
  const CustomerUpdateCartReq({
    this.regionId,
    this.email,
    this.currencyCode,
    this.salesChannelId,
    this.locale,
    this.shippingAddress,
    this.billingAddress,
  });

  final String? regionId;
  final String? email;
  final String? currencyCode;
  final String? salesChannelId;
  final String? locale;
  final CustomerCartAddressReq? shippingAddress;
  final CustomerCartAddressReq? billingAddress;

  Map<String, dynamic> toJson() {
    return {
      if (regionId != null) 'region_id': regionId,
      if (email != null) 'email': email,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (salesChannelId != null) 'sales_channel_id': salesChannelId,
      if (locale != null) 'locale': locale,
      if (shippingAddress != null)
        'shipping_address': shippingAddress!.toJson(),
      if (billingAddress != null)
        'billing_address': billingAddress!.toJson(),
    };
  }

  factory CustomerUpdateCartReq.fromJson(Map<String, dynamic> json) {
    final rawShipping = json['shipping_address'];
    final rawBilling = json['billing_address'];
    return CustomerUpdateCartReq(
      regionId: json['region_id'] as String?,
      email: json['email'] as String?,
      currencyCode: json['currency_code'] as String?,
      salesChannelId: json['sales_channel_id'] as String?,
      locale: json['locale'] as String?,
      shippingAddress: rawShipping is Map<String, dynamic>
          ? CustomerCartAddressReq.fromJson(rawShipping)
          : null,
      billingAddress: rawBilling is Map<String, dynamic>
          ? CustomerCartAddressReq.fromJson(rawBilling)
          : null,
    );
  }
}

/// Body of `POST /store/carts/:id/line-items/:line_id`.
/// `quantity: 0` removes the item from the cart.
class CustomerUpdateLineItemReq {
  const CustomerUpdateLineItemReq({required this.quantity});

  final int quantity;

  Map<String, dynamic> toJson() => {'quantity': quantity};

  factory CustomerUpdateLineItemReq.fromJson(Map<String, dynamic> json) {
    return CustomerUpdateLineItemReq(
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Body of `POST` / `DELETE /store/carts/:id/promotions`.
class CustomerCartPromotionsReq {
  const CustomerCartPromotionsReq({required this.promoCodes});

  final List<String> promoCodes;

  Map<String, dynamic> toJson() => {'promo_codes': promoCodes};

  factory CustomerCartPromotionsReq.fromJson(Map<String, dynamic> json) {
    final raw = json['promo_codes'];
    return CustomerCartPromotionsReq(
      promoCodes:
          raw is List ? raw.whereType<String>().toList() : const [],
    );
  }
}

/// Body of `POST /store/carts/:id/shipping-methods` (single option).
class CustomerAddShippingMethodReq {
  const CustomerAddShippingMethodReq({required this.optionId});

  final String optionId;

  Map<String, dynamic> toJson() => {'option_id': optionId};

  factory CustomerAddShippingMethodReq.fromJson(Map<String, dynamic> json) {
    return CustomerAddShippingMethodReq(
      optionId: json['option_id'] as String,
    );
  }
}
