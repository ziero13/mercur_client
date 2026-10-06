import 'package:dio/dio.dart';

import '../../models/models.dart';
import '../auth_sink.dart';

/// Vendor auth: member login (`POST /auth/member/emailpass`).
///
/// Seller scoping (`x-seller-id` or `POST /vendor/sellers/select`) is a
/// separate step on the seller tranche — login only installs the member
/// Bearer.
class SellerAuthResource {
  SellerAuthResource(this._dio, {this.onMemberToken});

  final Dio _dio;
  final AuthTokenSink? onMemberToken;

  Future<TokenRes> login(LoginReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/member/emailpass',
      data: body.toJson(),
    );
    final token = TokenRes.fromJson(res.data ?? const {});
    onMemberToken?.call(token.token);
    return token;
  }
}
