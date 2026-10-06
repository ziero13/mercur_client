import 'package:dio/dio.dart';

import '../../models/models.dart';
import '../auth_sink.dart';

/// Admin auth: operator login (`POST /auth/user/emailpass`).
class AdminAuthResource {
  AdminAuthResource(this._dio, {this.onUserToken});

  final Dio _dio;
  final AuthTokenSink? onUserToken;

  Future<TokenRes> login(LoginReq body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/user/emailpass',
      data: body.toJson(),
    );
    final token = TokenRes.fromJson(res.data ?? const {});
    onUserToken?.call(token.token);
    return token;
  }
}
