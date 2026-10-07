import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Admin sellers (`/admin/sellers/*`) — operator management of marketplace
/// sellers: CRUD, lifecycle transitions (approve / suspend / unsuspend /
/// terminate / unterminate), detail upserts, team and invites, products.
class AdminSellersResource {
  AdminSellersResource(this._dio);

  final Dio _dio;

  /// `GET /admin/sellers`.
  Future<AdminSellerListRes> list([AdminListSellersParams? query]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/admin/sellers',
      queryParameters: query?.toQuery(),
    );
    return AdminSellerListRes.fromJson(res.data ?? const {});
  }

  /// `GET /admin/sellers/:id`.
  Future<AdminSellerRes> retrieve(
    String id, [
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/admin/sellers/$id',
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers`.
  Future<AdminSellerRes> create(
    AdminCreateSellerReq body, [
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id`.
  Future<AdminSellerRes> update(
    String id,
    AdminUpdateSellerReq body, [
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/approve` (`pending_approval` → `open`).
  Future<AdminSellerRes> approve(
    String id, [
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/approve',
      data: const {},
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/suspend` (reason → `status_reason`).
  Future<AdminSellerRes> suspend(
    String id, [
    AdminSellerStatusReasonReq? body,
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/suspend',
      data: (body ?? const AdminSellerStatusReasonReq()).toJson(),
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/unsuspend` (→ `open`).
  Future<AdminSellerRes> unsuspend(
    String id, [
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/unsuspend',
      data: const {},
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/terminate` (reason → `status_reason`).
  Future<AdminSellerRes> terminate(
    String id, [
    AdminSellerStatusReasonReq? body,
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/terminate',
      data: (body ?? const AdminSellerStatusReasonReq()).toJson(),
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/unterminate` (→ `open`).
  Future<AdminSellerRes> unterminate(
    String id, [
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/unterminate',
      data: const {},
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/address` (upsert).
  Future<AdminSellerRes> upsertAddress(
    String id,
    AdminUpsertSellerAddressReq body, [
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/address',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/payment-details` (upsert).
  Future<AdminSellerRes> upsertPaymentDetails(
    String id,
    AdminUpsertSellerPaymentDetailsReq body, [
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/payment-details',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/professional-details` (upsert).
  Future<AdminSellerRes> upsertProfessionalDetails(
    String id,
    AdminUpsertSellerProfessionalDetailsReq body, [
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/professional-details',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /admin/sellers/:id/professional-details`.
  Future<AdminSellerRes> deleteProfessionalDetails(
    String id, [
    AdminRetrieveSellerParams? query,
  ]) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/admin/sellers/$id/professional-details',
      queryParameters: query?.toQuery(),
    );
    return AdminSellerRes.fromJson(res.data ?? const {});
  }

  /// `GET /admin/sellers/:id/members`.
  Future<AdminSellerMembersRes> listMembers(
    String id, [
    AdminListSellerMembersParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/admin/sellers/$id/members',
      queryParameters: query?.toQuery(),
    );
    return AdminSellerMembersRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/members` (link an existing member).
  Future<AdminSellerMemberRes> addMember(
    String id,
    AdminAddSellerMemberReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/members',
      data: body.toJson(),
    );
    return AdminSellerMemberRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /admin/sellers/:id/members/:member_id`.
  Future<AdminDeletedRes> removeMember(String id, String memberId) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/admin/sellers/$id/members/$memberId',
    );
    return AdminDeletedRes.fromJson(res.data ?? const {});
  }

  /// `GET /admin/sellers/:id/members/invites`.
  Future<AdminMemberInviteListRes> listInvites(
    String id, [
    AdminListMemberInvitesParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/admin/sellers/$id/members/invites',
      queryParameters: query?.toQuery(),
    );
    return AdminMemberInviteListRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/members/invite`.
  Future<AdminMemberInviteRes> inviteMember(
    String id,
    AdminInviteSellerMemberReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/members/invite',
      data: body.toJson(),
    );
    return AdminMemberInviteRes.fromJson(res.data ?? const {});
  }

  /// `POST /admin/sellers/:id/members/invites/:invite_id/resend`.
  Future<AdminMemberInviteRes> resendInvite(
    String id,
    String inviteId,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/admin/sellers/$id/members/invites/$inviteId/resend',
      data: const {},
    );
    return AdminMemberInviteRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /admin/sellers/:id/members/invites/:invite_id`.
  Future<AdminDeletedRes> deleteInvite(String id, String inviteId) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/admin/sellers/$id/members/invites/$inviteId',
    );
    return AdminDeletedRes.fromJson(res.data ?? const {});
  }

  /// `GET /admin/sellers/:id/products`.
  Future<AdminSellerProductsRes> listProducts(
    String id, [
    AdminListSellerProductsParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/admin/sellers/$id/products',
      queryParameters: query?.toQuery(),
    );
    return AdminSellerProductsRes.fromJson(res.data ?? const {});
  }
}
