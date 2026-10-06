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
