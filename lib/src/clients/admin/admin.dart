import 'package:dio/dio.dart';

import '../../models/models.dart';
import '../auth_sink.dart';
import 'auth_resource.dart';

/// Admin entry point — the `/admin/*` surface.
///
/// Tranche auth: operator login. Domain resources (sellers, products,
/// offers, …) land in the admin tranche.
class AdminClient {
  AdminClient(Dio dio, {AuthTokenSink? onUserToken})
      : auth = AdminAuthResource(dio, onUserToken: onUserToken);

  final AdminAuthResource auth;

  Future<TokenRes> login(LoginReq body) => auth.login(body);
}
