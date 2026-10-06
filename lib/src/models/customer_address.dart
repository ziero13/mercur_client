/// Store customer address (`/store/customers/me/addresses/*`).
///
/// Only `id` is required — partial `fields` selections fall back to
/// neutral defaults (see AGENTS.md).
class CustomerAddress {
  const CustomerAddress({
    required this.id,
    this.addressName,
    this.isDefaultShipping,
    this.isDefaultBilling,
    this.customerId,
    this.company,
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.city,
    this.countryCode,
    this.province,
    this.postalCode,
    this.phone,
  });

  final String id;
  final String? addressName;
  final bool? isDefaultShipping;
  final bool? isDefaultBilling;
  final String? customerId;
  final String? company;
  final String? firstName;
  final String? lastName;
  final String? address1;
  final String? address2;
  final String? city;
  final String? countryCode;
  final String? province;
  final String? postalCode;
  final String? phone;

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      id: json['id'] as String,
      addressName: json['address_name'] as String?,
      isDefaultShipping: json['is_default_shipping'] as bool?,
      isDefaultBilling: json['is_default_billing'] as bool?,
      customerId: json['customer_id'] as String?,
      company: json['company'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      address1: json['address_1'] as String?,
      address2: json['address_2'] as String?,
      city: json['city'] as String?,
      countryCode: json['country_code'] as String?,
      province: json['province'] as String?,
      postalCode: json['postal_code'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (addressName != null) 'address_name': addressName,
      if (isDefaultShipping != null)
        'is_default_shipping': isDefaultShipping,
      if (isDefaultBilling != null) 'is_default_billing': isDefaultBilling,
      if (customerId != null) 'customer_id': customerId,
      if (company != null) 'company': company,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (address1 != null) 'address_1': address1,
      if (address2 != null) 'address_2': address2,
      if (city != null) 'city': city,
      if (countryCode != null) 'country_code': countryCode,
      if (province != null) 'province': province,
      if (postalCode != null) 'postal_code': postalCode,
      if (phone != null) 'phone': phone,
    };
  }
}
