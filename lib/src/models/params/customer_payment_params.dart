/// Field selection for the store payment-collection POSTs
/// (both accept `?fields` via the shared select-params middleware).
class CustomerPaymentCollectionParams {
  const CustomerPaymentCollectionParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerPaymentCollectionParams.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawFields = json['fields'];
    return CustomerPaymentCollectionParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}
