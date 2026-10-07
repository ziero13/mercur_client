import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Vendor seller details + team (`/vendor/sellers/:id/*`).
///
/// All routes are scoped: the caller authenticates as member and sends
/// `x-seller-id` (installed automatically after `select`).
class SellerTeamResource {
  SellerTeamResource(this._dio);

  final Dio _dio;

  /// `POST /vendor/sellers/:id/address` → `{seller}`.
  Future<SellerCurrentRes> upsertAddress(
    String id,
    SellerAddressReq body, [
    SellerDetailFieldsParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/sellers/$id/address',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return SellerCurrentRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/sellers/:id/payment-details` → `{seller}`.
  Future<SellerCurrentRes> upsertPaymentDetails(
    String id,
    SellerPaymentDetailsReq body, [
    SellerDetailFieldsParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/sellers/$id/payment-details',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return SellerCurrentRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/sellers/:id/professional-details` → `{seller}`.
  Future<SellerCurrentRes> upsertProfessionalDetails(
    String id,
    SellerProfessionalDetailsReq body, [
    SellerDetailFieldsParams? query,
  ]) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/sellers/$id/professional-details',
      data: body.toJson(),
      queryParameters: query?.toQuery(),
    );
    return SellerCurrentRes.fromJson(res.data ?? const {});
  }

  /// `DELETE /vendor/sellers/:id/professional-details` → `{seller}`.
  Future<SellerCurrentRes> deleteProfessionalDetails(
    String id, [
    SellerDetailFieldsParams? query,
  ]) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/sellers/$id/professional-details',
      queryParameters: query?.toQuery(),
    );
    return SellerCurrentRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/sellers/:id/members` → `{seller_members, …}`.
  Future<SellerTeamListRes> listMembers(
    String id, [
    SellerListTeamParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/sellers/$id/members',
      queryParameters: query?.toQuery(),
    );
    return SellerTeamListRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/sellers/:id/members` → `{member_invite}`.
  Future<MemberInviteRes> inviteMember(
    String id,
    SellerInviteMemberReq body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/sellers/$id/members',
      data: body.toJson(),
    );
    return MemberInviteRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/sellers/:id/members/:member_id` — empty object on
  /// success (role change).
  Future<void> updateMemberRole(
    String id,
    String memberId,
    SellerUpdateMemberRoleReq body,
  ) async {
    await _dio.post<Map<String, dynamic>>(
      '/vendor/sellers/$id/members/$memberId',
      data: body.toJson(),
    );
  }

  /// `DELETE /vendor/sellers/:id/members/:member_id` → deletion flag.
  Future<SellerMemberDeleteRes> removeMember(
    String id,
    String memberId,
  ) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '/vendor/sellers/$id/members/$memberId',
    );
    return SellerMemberDeleteRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/sellers/:id/members/me` → `{seller_member}`.
  Future<SellerTeamMemberRes> retrieveMemberMe(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/sellers/$id/members/me',
    );
    return SellerTeamMemberRes.fromJson(res.data ?? const {});
  }

  /// `GET /vendor/sellers/:id/members/invites` → `{member_invites, …}`.
  Future<MemberInviteListRes> listInvites(
    String id, [
    SellerListTeamParams? query,
  ]) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/vendor/sellers/$id/members/invites',
      queryParameters: query?.toQuery(),
    );
    return MemberInviteListRes.fromJson(res.data ?? const {});
  }
}

/// Current member profile (`/vendor/members/*`).
class SellerMembersResource {
  SellerMembersResource(this._dio);

  final Dio _dio;

  /// `GET /vendor/members/me` → `{seller_member}` (scoped).
  Future<SellerTeamMemberRes> retrieveMe() async {
    final res = await _dio.get<Map<String, dynamic>>('/vendor/members/me');
    return SellerTeamMemberRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/members/me` → `{seller_member}` (scoped).
  Future<SellerTeamMemberRes> updateMe(MemberUpdateMeReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/members/me',
      data: body.toJson(),
    );
    return SellerTeamMemberRes.fromJson(res.data ?? const {});
  }

  /// `POST /vendor/members/invites/accept` → `{member}` (public).
  Future<MemberAcceptRes> acceptInvite(MemberAcceptInviteReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/members/invites/accept',
      data: body.toJson(),
    );
    return MemberAcceptRes.fromJson(res.data ?? const {});
  }
}
