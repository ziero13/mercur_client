/// Base for every list query: offset pagination + search + field
/// selection. Serialised to query parameters at the Dio boundary
/// (inside resources) — never exposed as a `Map` to callers.
class PaginationParams {
  const PaginationParams({
    this.limit,
    this.offset,
    this.order,
    this.q,
    this.fields,
  });

  final int? limit;
  final int? offset;

  /// Sort field, `-` prefix for descending (e.g. `-created_at`).
  final String? order;

  /// Free-text search, where the entity supports it.
  final String? q;

  /// Field selection. Entries may carry `+`/`-` merge prefixes or be bare
  /// (replace mode). Never mix bare with prefixed entries — prefixed wins.
  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (order != null) 'order': order,
      if (q != null) 'q': q,
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory PaginationParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return PaginationParams(
      limit: (json['limit'] as num?)?.toInt(),
      offset: (json['offset'] as num?)?.toInt(),
      order: json['order'] as String?,
      q: json['q'] as String?,
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List list => list.cast<String>(),
        _ => null,
      },
    );
  }
}
