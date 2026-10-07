import '../pagination_params.dart';

/// Query for `GET /store/shipping-options` (grouped by seller).
class CustomerListShippingOptionsParams {
  const CustomerListShippingOptionsParams({
    required this.cartId,
    this.isReturn,
    this.fields,
  });

  final String cartId;
  final bool? isReturn;
  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      'cart_id': cartId,
      if (isReturn != null) 'is_return': isReturn,
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerListShippingOptionsParams.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawFields = json['fields'];
    return CustomerListShippingOptionsParams(
      cartId: json['cart_id'] as String,
      isReturn: json['is_return'] as bool?,
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}

/// Query for `GET /store/regions`.
class CustomerListRegionsParams extends PaginationParams {
  const CustomerListRegionsParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
  });
}

/// Query for `GET /store/regions/:id`: field selection.
class CustomerRetrieveRegionParams {
  const CustomerRetrieveRegionParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerRetrieveRegionParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomerRetrieveRegionParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}
