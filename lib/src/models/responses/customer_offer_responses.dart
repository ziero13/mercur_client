import '../offer.dart';

/// Response of `GET /store/offers`.
class CustomerOfferListRes {
  const CustomerOfferListRes({
    required this.offers,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<Offer> offers;
  final int count;
  final int offset;
  final int limit;

  factory CustomerOfferListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['offers'];
    return CustomerOfferListRes(
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

/// Response of `GET /store/offers/:id`.
class CustomerOfferRes {
  const CustomerOfferRes({required this.offer});

  final Offer offer;

  factory CustomerOfferRes.fromJson(Map<String, dynamic> json) {
    return CustomerOfferRes(
      offer: Offer.fromJson(json['offer'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'offer': offer.toJson()};
}
