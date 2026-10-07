import '../seller.dart';
import '../seller_member.dart';
import '../seller_product.dart';

/// Response of `GET /admin/sellers`.
class AdminSellerListRes {
  const AdminSellerListRes({
    required this.sellers,
    required this.count,
    this.offset,
    this.limit,
  });

  final List<Seller> sellers;
  final int count;
  final int? offset;
  final int? limit;

  factory AdminSellerListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['sellers'];
    return AdminSellerListRes(
      sellers: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(Seller.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellers': sellers.map((s) => s.toJson()).toList(),
      'count': count,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };
  }
}

/// Response wrapping one `seller` (retrieve, create, update, lifecycle
/// transitions, detail upserts/deletes).
class AdminSellerRes {
  const AdminSellerRes({required this.seller});

  final Seller seller;

  factory AdminSellerRes.fromJson(Map<String, dynamic> json) {
    return AdminSellerRes(
      seller: Seller.fromJson(json['seller'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'seller': seller.toJson()};
}

/// Response of `GET /admin/sellers/:id/members`.
class AdminSellerMembersRes {
  const AdminSellerMembersRes({
    required this.sellerMembers,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerMember> sellerMembers;
  final int count;
  final int offset;
  final int limit;

  factory AdminSellerMembersRes.fromJson(Map<String, dynamic> json) {
    final raw = json['seller_members'];
    return AdminSellerMembersRes(
      sellerMembers: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerMember.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seller_members': sellerMembers.map((m) => m.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `seller_member`
/// (`POST /admin/sellers/:id/members`).
class AdminSellerMemberRes {
  const AdminSellerMemberRes({required this.sellerMember});

  final SellerMember sellerMember;

  factory AdminSellerMemberRes.fromJson(Map<String, dynamic> json) {
    return AdminSellerMemberRes(
      sellerMember:
          SellerMember.fromJson(json['seller_member'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'seller_member': sellerMember.toJson()};
}

/// Response wrapping one `member_invite` (invite + resend).
class AdminMemberInviteRes {
  const AdminMemberInviteRes({required this.invite});

  final MemberInvite invite;

  factory AdminMemberInviteRes.fromJson(Map<String, dynamic> json) {
    return AdminMemberInviteRes(
      invite:
          MemberInvite.fromJson(json['member_invite'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'member_invite': invite.toJson()};
}

/// Response of `GET /admin/sellers/:id/members/invites`.
class AdminMemberInviteListRes {
  const AdminMemberInviteListRes({
    required this.invites,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<MemberInvite> invites;
  final int count;
  final int offset;
  final int limit;

  factory AdminMemberInviteListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['member_invites'];
    return AdminMemberInviteListRes(
      invites: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(MemberInvite.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member_invites': invites.map((i) => i.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Deletion envelope (`DELETE .../members/:member_id`,
/// `DELETE .../invites/:invite_id`): `{id, object, deleted}`.
class AdminDeletedRes {
  const AdminDeletedRes({
    required this.id,
    required this.object,
    required this.deleted,
  });

  final String id;
  final String object;
  final bool deleted;

  factory AdminDeletedRes.fromJson(Map<String, dynamic> json) {
    return AdminDeletedRes(
      id: json['id'] as String,
      object: json['object'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'object': object,
    'deleted': deleted,
  };
}

/// Response of `GET /admin/sellers/:id/products`.
class AdminSellerProductsRes {
  const AdminSellerProductsRes({
    required this.products,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerProduct> products;
  final int count;
  final int offset;
  final int limit;

  factory AdminSellerProductsRes.fromJson(Map<String, dynamic> json) {
    final raw = json['products'];
    return AdminSellerProductsRes(
      products: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerProduct.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((p) => p.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}
