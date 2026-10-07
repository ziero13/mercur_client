/// Query for `GET /vendor/sellers` (member memberships, unscoped).
class SellerListMembershipsParams {
  const SellerListMembershipsParams({
    this.limit,
    this.offset,
    this.order,
    this.fields,
  });

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

  factory SellerListMembershipsParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return SellerListMembershipsParams(
      limit: (json['limit'] as num?)?.toInt(),
      offset: (json['offset'] as num?)?.toInt(),
      order: json['order'] as String?,
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}

/// Query for `GET /vendor/sellers/me`.
class SellerRetrieveCurrentParams {
  const SellerRetrieveCurrentParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory SellerRetrieveCurrentParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return SellerRetrieveCurrentParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}
