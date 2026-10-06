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
  });

  final String id;
  final String name;
  final String handle;
  final String? description;
  final String? logo;
  final String? banner;
  final bool? isPremium;

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
    };
  }
}
