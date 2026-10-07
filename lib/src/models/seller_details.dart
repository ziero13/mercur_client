/// Seller address entity (`address` in seller payloads).
class SellerAddress {
  const SellerAddress({
    this.name,
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

  final String? name;
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

  factory SellerAddress.fromJson(Map<String, dynamic> json) {
    return SellerAddress(
      name: json['name'] as String?,
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
      if (name != null) 'name': name,
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

/// Seller bank details entity (`payment_details` in seller payloads).
class SellerPaymentDetails {
  const SellerPaymentDetails({
    this.countryCode,
    this.holderName,
    this.bankName,
    this.iban,
    this.bic,
    this.routingNumber,
    this.accountNumber,
  });

  final String? countryCode;
  final String? holderName;
  final String? bankName;
  final String? iban;
  final String? bic;
  final String? routingNumber;
  final String? accountNumber;

  factory SellerPaymentDetails.fromJson(Map<String, dynamic> json) {
    return SellerPaymentDetails(
      countryCode: json['country_code'] as String?,
      holderName: json['holder_name'] as String?,
      bankName: json['bank_name'] as String?,
      iban: json['iban'] as String?,
      bic: json['bic'] as String?,
      routingNumber: json['routing_number'] as String?,
      accountNumber: json['account_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (countryCode != null) 'country_code': countryCode,
      if (holderName != null) 'holder_name': holderName,
      if (bankName != null) 'bank_name': bankName,
      if (iban != null) 'iban': iban,
      if (bic != null) 'bic': bic,
      if (routingNumber != null) 'routing_number': routingNumber,
      if (accountNumber != null) 'account_number': accountNumber,
    };
  }
}

/// Seller business registration entity (`professional_details` payloads).
class SellerProfessionalDetails {
  const SellerProfessionalDetails({
    this.corporateName,
    this.registrationNumber,
    this.taxId,
  });

  final String? corporateName;
  final String? registrationNumber;
  final String? taxId;

  factory SellerProfessionalDetails.fromJson(Map<String, dynamic> json) {
    return SellerProfessionalDetails(
      corporateName: json['corporate_name'] as String?,
      registrationNumber: json['registration_number'] as String?,
      taxId: json['tax_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (corporateName != null) 'corporate_name': corporateName,
      if (registrationNumber != null)
        'registration_number': registrationNumber,
      if (taxId != null) 'tax_id': taxId,
    };
  }
}
