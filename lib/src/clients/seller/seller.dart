import 'package:dio/dio.dart';

import '../../models/models.dart';
import '../auth_sink.dart';
import 'auth_resource.dart';
import 'sellers_resource.dart';

/// Seller entry point — the `/vendor/*` surface.
///
/// Tranche sellers+scope: memberships, registration, select (auto-scopes
/// the seller Dio), current seller retrieve/update. Domain resources
/// (offers, products, orders, …) land in later tranches.
class SellerClient {
  SellerClient(Dio dio, {AuthTokenSink? onMemberToken, SellerScopeSink? onSellerSelected})
      : auth = SellerAuthResource(dio, onMemberToken: onMemberToken),
        sellers = SellerSellersResource(
          dio,
          onSellerSelected: onSellerSelected,
        );

  final SellerAuthResource auth;
  final SellerSellersResource sellers;

  Future<TokenRes> login(LoginReq body) => auth.login(body);
}
