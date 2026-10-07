/// Body of `POST /vendor/sellers/select`.
class SellerSelectReq {
  const SellerSelectReq({required this.sellerId});

  final String sellerId;

  Map<String, dynamic> toJson() => {'seller_id': sellerId};

  factory SellerSelectReq.fromJson(Map<String, dynamic> json) {
    return SellerSelectReq(sellerId: json['seller_id'] as String);
  }
}

/// Body of `POST /vendor/sellers/me` (update current seller).
class SellerUpdateCurrentReq {
  const SellerUpdateCurrentReq({
    this.name,
    this.handle,
    this.email,
    this.phone,
    this.description,
    this.logo,
    this.banner,
    this.websiteUrl,
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
      if (closedFrom != null) 'closed_from': closedFrom,
      if (closedTo != null) 'closed_to': closedTo,
      if (closureNote != null) 'closure_note': closureNote,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory SellerUpdateCurrentReq.fromJson(Map<String, dynamic> json) {
    return SellerUpdateCurrentReq(
      name: json['name'] as String?,
      handle: json['handle'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      banner: json['banner'] as String?,
      websiteUrl: json['website_url'] as String?,
      closedFrom: json['closed_from'] as String?,
      closedTo: json['closed_to'] as String?,
      closureNote: json['closure_note'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

/// Body of `POST /vendor/sellers` (public registration).
class SellerCreateReq {
  const SellerCreateReq({
    required this.name,
    required this.email,
    required this.currencyCode,
    this.handle,
    this.phone,
    this.memberEmail,
    this.firstName,
    this.lastName,
    this.description,
    this.metadata,
  });

  final String name;
  final String email;
  final String currencyCode;
  final String? handle;
  final String? phone;
  final String? memberEmail;
  final String? firstName;
  final String? lastName;
  final String? description;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'currency_code': currencyCode,
      if (handle != null) 'handle': handle,
      if (phone != null) 'phone': phone,
      if (memberEmail != null) 'member_email': memberEmail,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (description != null) 'description': description,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory SellerCreateReq.fromJson(Map<String, dynamic> json) {
    return SellerCreateReq(
      name: json['name'] as String,
      email: json['email'] as String,
      currencyCode: json['currency_code'] as String,
      handle: json['handle'] as String?,
      phone: json['phone'] as String?,
      memberEmail: json['member_email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
