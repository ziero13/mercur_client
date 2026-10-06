import '../pagination_params.dart';

/// Restricted `fields` accepted by `GET /store/order-groups`.
///
/// Verified live: omitting `fields` fails 400 (relation-expansion cap on
/// `orders.items.variant.product.*`), so the list query defaults to this
/// set. Override only with fields from the route's allowed list.
const orderGroupRestrictedFields = [
  'id',
  'customer_id',
  'seller_count',
  'total',
  'created_at',
  'updated_at',
];

/// Query for `GET /store/order-groups` (customer JWT required).
class CustomerListOrderGroupsParams extends PaginationParams {
  const CustomerListOrderGroupsParams({
    super.limit,
    super.offset,
    super.order,
    super.fields = orderGroupRestrictedFields,
    this.id,
  }) : super(q: null);

  final List<String>? id;

  @override
  Map<String, dynamic> toQuery() {
    return {
      ...super.toQuery(),
      if (id != null && id!.isNotEmpty) 'id': id!.join(','),
    };
  }

  @override
  Map<String, dynamic> toJson() => toQuery();

  factory CustomerListOrderGroupsParams.fromJson(Map<String, dynamic> json) {
    List<String>? splitList(Object? raw) => switch (raw) {
          null => null,
          final String s => s.split(','),
          final List l => l.cast<String>(),
          _ => null,
        };
    final base = PaginationParams.fromJson(json);
    return CustomerListOrderGroupsParams(
      limit: base.limit,
      offset: base.offset,
      order: base.order,
      fields: base.fields ?? orderGroupRestrictedFields,
      id: splitList(json['id']),
    );
  }
}

/// Query for `GET /store/order-groups/:id` (customer JWT required).
///
/// Like the list route, detail defaults to [orderGroupRestrictedFields] —
/// verified live: the default expansion fails 400 on the relation cap.
class CustomerRetrieveOrderGroupParams {
  const CustomerRetrieveOrderGroupParams({
    this.fields = orderGroupRestrictedFields,
  });

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerRetrieveOrderGroupParams.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawFields = json['fields'];
    return CustomerRetrieveOrderGroupParams(
      fields: switch (rawFields) {
        null => orderGroupRestrictedFields,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => orderGroupRestrictedFields,
      },
    );
  }
}
