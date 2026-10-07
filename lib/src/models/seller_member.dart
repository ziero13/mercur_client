import 'seller.dart';

/// The member's role for one seller (`rbac_role` in list payloads).
class SellerRole {
  const SellerRole({required this.id, this.name});

  final String id;
  final String? name;

  factory SellerRole.fromJson(Map<String, dynamic> json) {
    return SellerRole(
      id: json['id'] as String,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
    };
  }
}

/// One seller membership (`GET /vendor/sellers` item).
///
/// Only `id` is required — partial `fields` selections fall back to
/// neutral defaults.
///
/// Live wire truth (seeded dev, Oct 2026): items carry flat `seller_id`
/// / `role_id` strings; the documented nested `rbac_role` object is
/// absent unless explicitly expanded via `fields`. Both shapes decode.
class SellerMember {
  const SellerMember({required this.id, this.seller, this.role, this.sellerId, this.roleId});

  final String id;
  final Seller? seller;
  final SellerRole? role;
  final String? sellerId;
  final String? roleId;

  factory SellerMember.fromJson(Map<String, dynamic> json) {
    Seller? seller;
    final rawSeller = json['seller'];
    if (rawSeller is Map<String, dynamic> && rawSeller['id'] is String) {
      seller = Seller.fromJson(rawSeller);
    }
    SellerRole? role;
    final rawRole = json['rbac_role'];
    if (rawRole is Map<String, dynamic> && rawRole['id'] is String) {
      role = SellerRole.fromJson(rawRole);
    }
    return SellerMember(
      id: json['id'] as String,
      seller: seller,
      role: role,
      sellerId: json['seller_id'] as String? ?? seller?.id,
      roleId: json['role_id'] as String? ?? role?.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (seller != null) 'seller': seller!.toJson(),
      if (role != null) 'rbac_role': role!.toJson(),
      if (sellerId != null) 'seller_id': sellerId,
      if (roleId != null) 'role_id': roleId,
    };
  }
}
