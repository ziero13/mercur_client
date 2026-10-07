import '../pagination_params.dart';

/// Query for `GET /admin/sellers`.
class AdminListSellersParams extends PaginationParams {
  const AdminListSellersParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
    this.ids,
    this.name,
    this.handle,
    this.email,
    this.status,
    this.isPremium,
  });

  final List<String>? ids;
  final List<String>? name;
  final String? handle;
  final String? email;
  final List<String>? status;
  final bool? isPremium;

  @override
  Map<String, dynamic> toQuery() {
    return {
      ...super.toQuery(),
      if (ids != null && ids!.isNotEmpty) 'id': ids,
      if (name != null && name!.isNotEmpty) 'name': name,
      if (handle != null) 'handle': handle,
      if (email != null) 'email': email,
      if (status != null && status!.isNotEmpty) 'status': status,
      if (isPremium != null) 'is_premium': isPremium,
    };
  }

  @override
  Map<String, dynamic> toJson() => toQuery();
}

/// Field selection for single-seller admin routes
/// (`GET /admin/sellers/:id` and every lifecycle/upsert POST).
class AdminRetrieveSellerParams {
  const AdminRetrieveSellerParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory AdminRetrieveSellerParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return AdminRetrieveSellerParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
    );
  }
}

/// Query for `GET /admin/sellers/:id/members`.
class AdminListSellerMembersParams extends PaginationParams {
  const AdminListSellerMembersParams({
    super.limit,
    super.offset,
    super.order,
    super.fields,
  });
}

/// Query for `GET /admin/sellers/:id/members/invites`.
class AdminListMemberInvitesParams extends PaginationParams {
  const AdminListMemberInvitesParams({
    super.limit,
    super.offset,
    super.order,
    super.fields,
  });
}

/// Query for `GET /admin/sellers/:id/products`.
class AdminListSellerProductsParams extends PaginationParams {
  const AdminListSellerProductsParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
    this.ids,
    this.status,
    this.collectionId,
    this.salesChannelId,
    this.typeId,
    this.tagId,
  });

  final List<String>? ids;
  final List<String>? status;
  final List<String>? collectionId;
  final List<String>? salesChannelId;
  final List<String>? typeId;
  final List<String>? tagId;

  @override
  Map<String, dynamic> toQuery() {
    return {
      ...super.toQuery(),
      if (ids != null && ids!.isNotEmpty) 'id': ids,
      if (status != null && status!.isNotEmpty) 'status': status,
      if (collectionId != null && collectionId!.isNotEmpty)
        'collection_id': collectionId,
      if (salesChannelId != null && salesChannelId!.isNotEmpty)
        'sales_channel_id': salesChannelId,
      if (typeId != null && typeId!.isNotEmpty) 'type_id': typeId,
      if (tagId != null && tagId!.isNotEmpty) 'tag_id': tagId,
    };
  }

  @override
  Map<String, dynamic> toJson() => toQuery();
}
