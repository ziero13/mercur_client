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

/// A seller team member's profile (`member` in member payloads).
class MemberProfile {
  const MemberProfile({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.locale,
  });

  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? locale;

  factory MemberProfile.fromJson(Map<String, dynamic> json) {
    return MemberProfile(
      id: json['id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      locale: json['locale'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (locale != null) 'locale': locale,
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
  const SellerMember({
    required this.id,
    this.seller,
    this.role,
    this.sellerId,
    this.roleId,
    this.isOwner,
    this.member,
    this.createdAt,
  });

  final String id;
  final Seller? seller;
  final SellerRole? role;
  final String? sellerId;
  final String? roleId;
  final bool? isOwner;
  final MemberProfile? member;
  final String? createdAt;

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
    MemberProfile? member;
    final rawMember = json['member'];
    if (rawMember is Map<String, dynamic> && rawMember['id'] is String) {
      member = MemberProfile.fromJson(rawMember);
    }
    return SellerMember(
      id: json['id'] as String,
      seller: seller,
      role: role,
      sellerId: json['seller_id'] as String? ?? seller?.id,
      roleId: json['role_id'] as String? ?? role?.id,
      isOwner: json['is_owner'] as bool?,
      member: member,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (seller != null) 'seller': seller!.toJson(),
      if (role != null) 'rbac_role': role!.toJson(),
      if (sellerId != null) 'seller_id': sellerId,
      if (roleId != null) 'role_id': roleId,
      if (isOwner != null) 'is_owner': isOwner,
      if (member != null) 'member': member!.toJson(),
      if (createdAt != null) 'created_at': createdAt,
    };
  }
}

/// A pending team invite (`member_invite` payloads).
class MemberInvite {
  const MemberInvite({
    required this.id,
    this.email,
    this.roleId,
    this.accepted,
    this.expiresAt,
  });

  final String id;
  final String? email;
  final String? roleId;
  final bool? accepted;
  final String? expiresAt;

  factory MemberInvite.fromJson(Map<String, dynamic> json) {
    return MemberInvite(
      id: json['id'] as String,
      email: json['email'] as String?,
      roleId: json['role_id'] as String?,
      accepted: json['accepted'] as bool?,
      expiresAt: json['expires_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (email != null) 'email': email,
      if (roleId != null) 'role_id': roleId,
      if (accepted != null) 'accepted': accepted,
      if (expiresAt != null) 'expires_at': expiresAt,
    };
  }
}
