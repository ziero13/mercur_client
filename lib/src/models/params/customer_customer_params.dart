import '../pagination_params.dart';

/// Query for `GET /store/customers/me` (customer JWT required).
class CustomerRetrieveMeParams {
  const CustomerRetrieveMeParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerRetrieveMeParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomerRetrieveMeParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}

/// Query for `GET /store/customers/me/addresses` (customer JWT required).
class CustomerListAddressesParams extends PaginationParams {
  const CustomerListAddressesParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
  });
}

/// Query for `GET /store/customers/me/addresses/:address_id`.
class CustomerRetrieveAddressParams {
  const CustomerRetrieveAddressParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerRetrieveAddressParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomerRetrieveAddressParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}
