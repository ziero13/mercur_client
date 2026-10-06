/// Query for `POST /store/carts/:id/complete`: field selection applied
/// to the returned order group.
class CustomerCompleteCartParams {
  const CustomerCompleteCartParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerCompleteCartParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomerCompleteCartParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}
