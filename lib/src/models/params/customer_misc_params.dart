import '../pagination_params.dart';

/// Query for `GET /store/currencies`.
class CustomerListCurrenciesParams extends PaginationParams {
  const CustomerListCurrenciesParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
  });
}

/// Query for `GET /store/currencies/:code`: field selection.
class CustomerRetrieveCurrencyParams {
  const CustomerRetrieveCurrencyParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerRetrieveCurrencyParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomerRetrieveCurrencyParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}

/// Query for `GET /store/payment-providers` (`region_id` required).
class CustomerListPaymentProvidersParams extends PaginationParams {
  const CustomerListPaymentProvidersParams({
    required this.regionId,
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
  });

  final String regionId;

  @override
  Map<String, dynamic> toQuery() {
    return {
      ...super.toQuery(),
      'region_id': regionId,
    };
  }

  @override
  Map<String, dynamic> toJson() => toQuery();
}
