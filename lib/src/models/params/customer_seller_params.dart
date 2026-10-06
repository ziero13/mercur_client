import '../pagination_params.dart';

/// Query for `GET /store/sellers` — only `open` sellers are returned.
class CustomerListSellersParams extends PaginationParams {
  const CustomerListSellersParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
    this.id,
    this.name,
    this.handle,
    this.isPremium,
  });

  final List<String>? id;
  final List<String>? name;
  final String? handle;
  final bool? isPremium;

  @override
  Map<String, dynamic> toQuery() {
    return {
      ...super.toQuery(),
      if (id != null && id!.isNotEmpty) 'id': id!.join(','),
      if (name != null && name!.isNotEmpty) 'name': name!.join(','),
      if (handle != null) 'handle': handle,
      if (isPremium != null) 'is_premium': isPremium,
    };
  }

  @override
  Map<String, dynamic> toJson() => toQuery();

  factory CustomerListSellersParams.fromJson(Map<String, dynamic> json) {
    List<String>? splitList(Object? raw) => switch (raw) {
          null => null,
          final String s => s.split(','),
          final List l => l.cast<String>(),
          _ => null,
        };
    final base = PaginationParams.fromJson(json);
    return CustomerListSellersParams(
      limit: base.limit,
      offset: base.offset,
      order: base.order,
      q: base.q,
      fields: base.fields,
      id: splitList(json['id']),
      name: splitList(json['name']),
      handle: json['handle'] as String?,
      isPremium: json['is_premium'] as bool?,
    );
  }
}

/// Query for `GET /store/sellers/:id`.
class CustomerRetrieveSellerParams {
  const CustomerRetrieveSellerParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerRetrieveSellerParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomerRetrieveSellerParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}
