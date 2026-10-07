import '../seller_member.dart';

/// Response of `GET /vendor/sellers/:id/members`.
class SellerTeamListRes {
  const SellerTeamListRes({
    required this.sellerMembers,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerMember> sellerMembers;
  final int count;
  final int offset;
  final int limit;

  factory SellerTeamListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['seller_members'];
    return SellerTeamListRes(
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
/// (`GET /vendor/sellers/:id/members/me`, `/vendor/members/me`).
class SellerTeamMemberRes {
  const SellerTeamMemberRes({required this.sellerMember});

  final SellerMember sellerMember;

  factory SellerTeamMemberRes.fromJson(Map<String, dynamic> json) {
    return SellerTeamMemberRes(
      sellerMember:
          SellerMember.fromJson(json['seller_member'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'seller_member': sellerMember.toJson()};
}

/// Response of `POST /vendor/sellers/:id/members` (invite).
class MemberInviteRes {
  const MemberInviteRes({required this.invite});

  final MemberInvite invite;

  factory MemberInviteRes.fromJson(Map<String, dynamic> json) {
    return MemberInviteRes(
      invite:
          MemberInvite.fromJson(json['member_invite'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'member_invite': invite.toJson()};
}

/// Response of `GET /vendor/sellers/:id/members/invites`.
class MemberInviteListRes {
  const MemberInviteListRes({
    required this.invites,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<MemberInvite> invites;
  final int count;
  final int offset;
  final int limit;

  factory MemberInviteListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['member_invites'];
    return MemberInviteListRes(
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

/// Response of `POST /vendor/members/invites/accept`.
class MemberAcceptRes {
  const MemberAcceptRes({required this.member});

  final MemberProfile member;

  factory MemberAcceptRes.fromJson(Map<String, dynamic> json) {
    return MemberAcceptRes(
      member: MemberProfile.fromJson(json['member'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'member': member.toJson()};
}

/// Deletion confirmation (`DELETE …/members/:member_id`).
class SellerMemberDeleteRes {
  const SellerMemberDeleteRes({
    required this.id,
    required this.object,
    required this.deleted,
  });

  final String id;
  final String object;
  final bool deleted;

  factory SellerMemberDeleteRes.fromJson(Map<String, dynamic> json) {
    return SellerMemberDeleteRes(
      id: json['id'] as String? ?? '',
      object: json['object'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'object': object, 'deleted': deleted};
}

/// Query for `GET /vendor/sellers/:id/members`.
class SellerListTeamParams {
  const SellerListTeamParams({this.limit, this.offset, this.order, this.fields});

  final int? limit;
  final int? offset;
  final String? order;
  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (order != null) 'order': order,
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}

/// Query for seller detail upserts (`fields` only).
class SellerDetailFieldsParams {
  const SellerDetailFieldsParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}
