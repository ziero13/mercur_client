/// Body of `POST /store/customers/me` (email is immutable here).
class CustomerUpdateReq {
  const CustomerUpdateReq({
    this.firstName,
    this.lastName,
    this.phone,
    this.companyName,
  });

  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? companyName;

  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phone != null) 'phone': phone,
      if (companyName != null) 'company_name': companyName,
    };
  }

  factory CustomerUpdateReq.fromJson(Map<String, dynamic> json) {
    return CustomerUpdateReq(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      companyName: json['company_name'] as String?,
    );
  }
}

/// Body of address create/update (`/store/customers/me/addresses`).
/// Same shape for both — all fields optional.
class CustomerAddressReq {
  const CustomerAddressReq({
    this.addressName,
    this.isDefaultShipping,
    this.isDefaultBilling,
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

  final String? addressName;
  final bool? isDefaultShipping;
  final bool? isDefaultBilling;
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

  Map<String, dynamic> toJson() {
    return {
      if (addressName != null) 'address_name': addressName,
      if (isDefaultShipping != null)
        'is_default_shipping': isDefaultShipping,
      if (isDefaultBilling != null) 'is_default_billing': isDefaultBilling,
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

  factory CustomerAddressReq.fromJson(Map<String, dynamic> json) {
    return CustomerAddressReq(
      addressName: json['address_name'] as String?,
      isDefaultShipping: json['is_default_shipping'] as bool?,
      isDefaultBilling: json['is_default_billing'] as bool?,
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
}
