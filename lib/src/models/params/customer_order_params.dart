import '../pagination_params.dart';

/// Query for `GET /store/orders` (customer Bearer required).
class CustomerListOrdersParams extends PaginationParams {
  const CustomerListOrdersParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
    this.id,
    this.status,
  });

  final List<String>? id;
  final List<String>? status;

  @override
  Map<String, dynamic> toQuery() {
    return {
      ...super.toQuery(),
      if (id != null && id!.isNotEmpty) 'id': id!.join(','),
      if (status != null && status!.isNotEmpty)
        'status': status!.join(','),
    };
  }

  @override
  Map<String, dynamic> toJson() => toQuery();
}

/// Query for `GET /store/orders/:id`: field selection.
class CustomerRetrieveOrderParams {
  const CustomerRetrieveOrderParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerRetrieveOrderParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomerRetrieveOrderParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}

/// Query for `GET /store/return-reasons`.
class CustomerListReturnReasonsParams extends PaginationParams {
  const CustomerListReturnReasonsParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
  });
}

/// Query for `GET /store/return-reasons/:id`: field selection.
class CustomerRetrieveReturnReasonParams {
  const CustomerRetrieveReturnReasonParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerRetrieveReturnReasonParams.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawFields = json['fields'];
    return CustomerRetrieveReturnReasonParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}
