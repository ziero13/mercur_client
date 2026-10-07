/// Seller as exposed on the Store surface (`GET /store/sellers`).
///
/// Shared entity: identical shape on all three surfaces, so it lives
/// unprefixed. Store lists only return `open` sellers outside any
/// scheduled closure window.
class Seller {
  const Seller({
    required this.id,
    required this.name,
    required this.handle,
    this.description,
    this.logo,
    this.banner,
    this.isPremium,
    this.email,
    this.phone,
    this.websiteUrl,
    this.currencyCode,
    this.status,
    this.approvedAt,
    this.metadata,
  });

  final String id;
  final String name;
  final String handle;
  final String? description;
  final String? logo;
  final String? banner;
  final bool? isPremium;
  final String? email;
  final String? phone;
  final String? websiteUrl;
  final String? currencyCode;
  final String? status;
  final String? approvedAt;
  final Map<String, dynamic>? metadata;

  /// Only `id` is required; missing display fields (partial `fields`
  /// selection) fall back to empty strings rather than throwing.
  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      banner: json['banner'] as String?,
      isPremium: json['is_premium'] as bool?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      websiteUrl: json['website_url'] as String?,
      currencyCode: json['currency_code'] as String?,
      status: json['status'] as String?,
      approvedAt: json['approved_at'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      if (description != null) 'description': description,
      if (logo != null) 'logo': logo,
      if (banner != null) 'banner': banner,
      if (isPremium != null) 'is_premium': isPremium,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (websiteUrl != null) 'website_url': websiteUrl,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (status != null) 'status': status,
      if (approvedAt != null) 'approved_at': approvedAt,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
