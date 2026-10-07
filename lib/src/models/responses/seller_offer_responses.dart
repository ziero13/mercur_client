import '../offer.dart';

/// Response of `GET /vendor/offers` and `POST /vendor/offers/batch`.
class SellerOfferListRes {
  const SellerOfferListRes({
    required this.offers,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<Offer> offers;
  final int count;
  final int offset;
  final int limit;

  factory SellerOfferListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['offers'];
    return SellerOfferListRes(
      offers: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(Offer.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offers': offers.map((o) => o.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `offer`
/// (create / retrieve / update / inventory batch).
class SellerOfferRes {
  const SellerOfferRes({required this.offer});

  final Offer offer;

  factory SellerOfferRes.fromJson(Map<String, dynamic> json) {
    return SellerOfferRes(
      offer: Offer.fromJson(json['offer'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'offer': offer.toJson()};
}

/// Deletion confirmation (`DELETE /vendor/offers/:id`).
class SellerOfferDeleteRes {
  const SellerOfferDeleteRes({
    required this.id,
    required this.object,
    required this.deleted,
  });

  final String id;
  final String object;
  final bool deleted;

  factory SellerOfferDeleteRes.fromJson(Map<String, dynamic> json) {
    return SellerOfferDeleteRes(
      id: json['id'] as String? ?? '',
      object: json['object'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'object': object, 'deleted': deleted};
}
