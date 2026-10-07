import '../pagination_params.dart';

/// Shared list query for the store catalog reads.
class CustomerCatalogListParams extends PaginationParams {
  const CustomerCatalogListParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
  });
}

/// Shared retrieve query (field selection) for the store catalog reads.
class CustomerCatalogRetrieveParams {
  const CustomerCatalogRetrieveParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerCatalogRetrieveParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomerCatalogRetrieveParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}
