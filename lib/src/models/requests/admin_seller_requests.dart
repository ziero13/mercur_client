/// Body of `POST /admin/sellers` (operator-created seller + owner member).
///
/// `member.email` must belong to an existing or invited user; the seller
/// lands in `pending_approval` unless [status] says otherwise.
class AdminCreateSellerReq {
  const AdminCreateSellerReq({
    required this.name,
    required this.email,
    required this.currencyCode,
    required this.memberEmail,
    this.handle,
    this.phone,
    this.description,
    this.logo,
    this.banner,
    this.websiteUrl,
    this.externalId,
    this.status,
    this.statusReason,
    this.isPremium,
    this.closedFrom,
    this.closedTo,
    this.closureNote,
    this.metadata,
  });

  final String name;
  final String email;
  final String currencyCode;
  final String memberEmail;
  final String? handle;
  final String? phone;
  final String? description;
  final String? logo;
  final String? banner;
  final String? websiteUrl;
  final String? externalId;
  final String? status;
  final String? statusReason;
  final bool? isPremium;
  final String? closedFrom;
  final String? closedTo;
  final String? closureNote;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'currency_code': currencyCode,
      'member': {'email': memberEmail},
      if (handle != null) 'handle': handle,
      if (phone != null) 'phone': phone,
      if (description != null) 'description': description,
      if (logo != null) 'logo': logo,
      if (banner != null) 'banner': banner,
      if (websiteUrl != null) 'website_url': websiteUrl,
      if (externalId != null) 'external_id': externalId,
      if (status != null) 'status': status,
      if (statusReason != null) 'status_reason': statusReason,
      if (isPremium != null) 'is_premium': isPremium,
      if (closedFrom != null) 'closed_from': closedFrom,
      if (closedTo != null) 'closed_to': closedTo,
      if (closureNote != null) 'closure_note': closureNote,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory AdminCreateSellerReq.fromJson(Map<String, dynamic> json) {
    final rawMember = json['member'];
    return AdminCreateSellerReq(
      name: json['name'] as String,
      email: json['email'] as String,
      currencyCode: json['currency_code'] as String,
      memberEmail: rawMember is Map<String, dynamic>
          ? rawMember['email'] as String
          : '',
      handle: json['handle'] as String?,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      banner: json['banner'] as String?,
      websiteUrl: json['website_url'] as String?,
      externalId: json['external_id'] as String?,
      status: json['status'] as String?,
      statusReason: json['status_reason'] as String?,
      isPremium: json['is_premium'] as bool?,
      closedFrom: json['closed_from'] as String?,
      closedTo: json['closed_to'] as String?,
      closureNote: json['closure_note'] as String?,
      metadata: json['metadata'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null,
    );
  }
}

/// Body of `POST /admin/sellers/:id` (all fields optional).
class AdminUpdateSellerReq {
  const AdminUpdateSellerReq({
    this.name,
    this.handle,
    this.email,
    this.phone,
    this.description,
    this.logo,
    this.banner,
    this.websiteUrl,
    this.externalId,
    this.status,
    this.statusReason,
    this.isPremium,
    this.closedFrom,
    this.closedTo,
    this.closureNote,
    this.metadata,
  });

  final String? name;
  final String? handle;
  final String? email;
  final String? phone;
  final String? description;
  final String? logo;
  final String? banner;
  final String? websiteUrl;
  final String? externalId;
  final String? status;
  final String? statusReason;
  final bool? isPremium;
  final String? closedFrom;
  final String? closedTo;
  final String? closureNote;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (handle != null) 'handle': handle,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (description != null) 'description': description,
      if (logo != null) 'logo': logo,
      if (banner != null) 'banner': banner,
      if (websiteUrl != null) 'website_url': websiteUrl,
      if (externalId != null) 'external_id': externalId,
      if (status != null) 'status': status,
      if (statusReason != null) 'status_reason': statusReason,
      if (isPremium != null) 'is_premium': isPremium,
      if (closedFrom != null) 'closed_from': closedFrom,
      if (closedTo != null) 'closed_to': closedTo,
      if (closureNote != null) 'closure_note': closureNote,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory AdminUpdateSellerReq.fromJson(Map<String, dynamic> json) {
    return AdminUpdateSellerReq(
      name: json['name'] as String?,
      handle: json['handle'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      banner: json['banner'] as String?,
      websiteUrl: json['website_url'] as String?,
      externalId: json['external_id'] as String?,
      status: json['status'] as String?,
      statusReason: json['status_reason'] as String?,
      isPremium: json['is_premium'] as bool?,
      closedFrom: json['closed_from'] as String?,
      closedTo: json['closed_to'] as String?,
      closureNote: json['closure_note'] as String?,
      metadata: json['metadata'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null,
    );
  }
}

/// Optional reason body for `.../suspend` and `.../terminate`
/// (stored in `status_reason`).
class AdminSellerStatusReasonReq {
  const AdminSellerStatusReasonReq({this.reason});

  final String? reason;

  Map<String, dynamic> toJson() {
    return {if (reason != null) 'reason': reason};
  }

  factory AdminSellerStatusReasonReq.fromJson(Map<String, dynamic> json) {
    return AdminSellerStatusReasonReq(reason: json['reason'] as String?);
  }
}

/// Body of `POST /admin/sellers/:id/address` (upsert).
class AdminUpsertSellerAddressReq {
  const AdminUpsertSellerAddressReq({
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
    this.metadata,
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
  final Map<String, dynamic>? metadata;

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
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory AdminUpsertSellerAddressReq.fromJson(Map<String, dynamic> json) {
    return AdminUpsertSellerAddressReq(
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
      metadata: json['metadata'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null,
    );
  }
}

/// Body of `POST /admin/sellers/:id/payment-details` (upsert).
class AdminUpsertSellerPaymentDetailsReq {
  const AdminUpsertSellerPaymentDetailsReq({
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

  factory AdminUpsertSellerPaymentDetailsReq.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminUpsertSellerPaymentDetailsReq(
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

/// Body of `POST /admin/sellers/:id/professional-details` (upsert).
class AdminUpsertSellerProfessionalDetailsReq {
  const AdminUpsertSellerProfessionalDetailsReq({
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

  factory AdminUpsertSellerProfessionalDetailsReq.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminUpsertSellerProfessionalDetailsReq(
      corporateName: json['corporate_name'] as String?,
      registrationNumber: json['registration_number'] as String?,
      taxId: json['tax_id'] as String?,
    );
  }
}

/// Body of `POST /admin/sellers/:id/members` (link an existing member).
class AdminAddSellerMemberReq {
  const AdminAddSellerMemberReq({required this.memberId, required this.roleId});

  final String memberId;
  final String roleId;

  Map<String, dynamic> toJson() => {
    'member_id': memberId,
    'role_id': roleId,
  };

  factory AdminAddSellerMemberReq.fromJson(Map<String, dynamic> json) {
    return AdminAddSellerMemberReq(
      memberId: json['member_id'] as String,
      roleId: json['role_id'] as String,
    );
  }
}

/// Body of `POST /admin/sellers/:id/members/invite`.
class AdminInviteSellerMemberReq {
  const AdminInviteSellerMemberReq({required this.email, required this.roleId});

  final String email;
  final String roleId;

  Map<String, dynamic> toJson() => {'email': email, 'role_id': roleId};

  factory AdminInviteSellerMemberReq.fromJson(Map<String, dynamic> json) {
    return AdminInviteSellerMemberReq(
      email: json['email'] as String,
      roleId: json['role_id'] as String,
    );
  }
}
