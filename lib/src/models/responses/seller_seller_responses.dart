import '../seller.dart';
import '../seller_member.dart';

/// Response of `GET /vendor/sellers` (memberships, unscoped).
class SellerMembershipListRes {
  const SellerMembershipListRes({
    required this.sellerMembers,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerMember> sellerMembers;
  final int count;
  final int offset;
  final int limit;

  factory SellerMembershipListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['seller_members'];
    return SellerMembershipListRes(
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

/// Response of `GET /vendor/sellers/me` and `POST /vendor/sellers/me`.
class SellerCurrentRes {
  const SellerCurrentRes({required this.seller});

  final Seller seller;

  factory SellerCurrentRes.fromJson(Map<String, dynamic> json) {
    return SellerCurrentRes(
      seller: Seller.fromJson(json['seller'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'seller': seller.toJson()};
}

/// Response of `POST /vendor/sellers/select`.
class SellerSelectRes {
  const SellerSelectRes({required this.success, required this.sellerId});

  final bool success;
  final String sellerId;

  factory SellerSelectRes.fromJson(Map<String, dynamic> json) {
    return SellerSelectRes(
      success: json['success'] as bool? ?? false,
      sellerId: json['seller_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() =>
      {'success': success, 'seller_id': sellerId};
}

/// Response of `POST /vendor/sellers` (registration).
class SellerCreateRes {
  const SellerCreateRes({required this.seller});

  final Seller seller;

  factory SellerCreateRes.fromJson(Map<String, dynamic> json) {
    return SellerCreateRes(
      seller: Seller.fromJson(json['seller'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'seller': seller.toJson()};
}
