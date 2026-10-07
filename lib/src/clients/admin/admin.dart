import 'package:dio/dio.dart';

import '../../models/models.dart';
import '../auth_sink.dart';
import 'auth_resource.dart';
import 'sellers_resource.dart';

/// Admin entry point — the `/admin/*` surface.
///
/// Tranche 1: auth + sellers (CRUD, lifecycle, details, team, products).
class AdminClient {
  AdminClient(Dio dio, {AuthTokenSink? onUserToken})
      : auth = AdminAuthResource(dio, onUserToken: onUserToken),
        sellers = AdminSellersResource(dio);

  final AdminAuthResource auth;
  final AdminSellersResource sellers;

  Future<TokenRes> login(LoginReq body) => auth.login(body);
}
