/// Body of `POST /vendor/sellers/:id/address`.
class SellerAddressReq {
  const SellerAddressReq({
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

  factory SellerAddressReq.fromJson(Map<String, dynamic> json) {
    return SellerAddressReq(
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
}

/// Body of `POST /vendor/sellers/:id/payment-details`.
class SellerPaymentDetailsReq {
  const SellerPaymentDetailsReq({
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

  factory SellerPaymentDetailsReq.fromJson(Map<String, dynamic> json) {
    return SellerPaymentDetailsReq(
      countryCode: json['country_code'] as String?,
      holderName: json['holder_name'] as String?,
      bankName: json['bank_name'] as String?,
      iban: json['iban'] as String?,
      bic: json['bic'] as String?,
      routingNumber: json['routing_number'] as String?,
      accountNumber: json['account_number'] as String?,
    );
  }
}

/// Body of `POST /vendor/sellers/:id/professional-details`.
class SellerProfessionalDetailsReq {
  const SellerProfessionalDetailsReq({
    this.corporateName,
    this.registrationNumber,
    this.taxId,
  });

  final String? corporateName;
  final String? registrationNumber;
  final String? taxId;

  Map<String, dynamic> toJson() {
    return {
      if (corporateName != null) 'corporate_name': corporateName,
      if (registrationNumber != null)
        'registration_number': registrationNumber,
      if (taxId != null) 'tax_id': taxId,
    };
  }

  factory SellerProfessionalDetailsReq.fromJson(
      Map<String, dynamic> json) {
    return SellerProfessionalDetailsReq(
      corporateName: json['corporate_name'] as String?,
      registrationNumber: json['registration_number'] as String?,
      taxId: json['tax_id'] as String?,
    );
  }
}

/// Body of `POST /vendor/sellers/:id/members` (invite).
class SellerInviteMemberReq {
  const SellerInviteMemberReq({required this.email, required this.roleId});

  final String email;
  final String roleId;

  Map<String, dynamic> toJson() => {'email': email, 'role_id': roleId};

  factory SellerInviteMemberReq.fromJson(Map<String, dynamic> json) {
    return SellerInviteMemberReq(
      email: json['email'] as String,
      roleId: json['role_id'] as String,
    );
  }
}

/// Body of `POST /vendor/sellers/:id/members/:member_id` (role change).
class SellerUpdateMemberRoleReq {
  const SellerUpdateMemberRoleReq({required this.roleId});

  final String roleId;

  Map<String, dynamic> toJson() => {'role_id': roleId};

  factory SellerUpdateMemberRoleReq.fromJson(Map<String, dynamic> json) {
    return SellerUpdateMemberRoleReq(roleId: json['role_id'] as String);
  }
}

/// Body of `POST /vendor/members/invites/accept` (public).
class MemberAcceptInviteReq {
  const MemberAcceptInviteReq({
    required this.inviteToken,
    this.firstName,
    this.lastName,
  });

  final String inviteToken;
  final String? firstName;
  final String? lastName;

  Map<String, dynamic> toJson() {
    return {
      'invite_token': inviteToken,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
    };
  }

  factory MemberAcceptInviteReq.fromJson(Map<String, dynamic> json) {
    return MemberAcceptInviteReq(
      inviteToken: json['invite_token'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }
}

/// Body of `POST /vendor/members/me`.
class MemberUpdateMeReq {
  const MemberUpdateMeReq({this.firstName, this.lastName, this.locale});

  final String? firstName;
  final String? lastName;
  final String? locale;

  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (locale != null) 'locale': locale,
    };
  }

  factory MemberUpdateMeReq.fromJson(Map<String, dynamic> json) {
    return MemberUpdateMeReq(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      locale: json['locale'] as String?,
    );
  }
}
