import 'package:dio/dio.dart';

import '../../models/models.dart';
import '../auth_sink.dart';
import 'auth_resource.dart';

/// Seller entry point — the `/vendor/*` surface.
///
/// Tranche auth: member login. Domain resources (offers, products,
/// orders, …) land in the seller tranche.
class SellerClient {
  SellerClient(Dio dio, {AuthTokenSink? onMemberToken})
      : auth = SellerAuthResource(dio, onMemberToken: onMemberToken);

  final SellerAuthResource auth;

  Future<TokenRes> login(LoginReq body) => auth.login(body);
}
