import 'package:dio/dio.dart';

import '../../models/models.dart';
import '../auth_sink.dart';
import 'auth_resource.dart';
import 'products_resource.dart';
import 'sellers_resource.dart';
import 'team_resource.dart';

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
        ),
        team = SellerTeamResource(dio),
        members = SellerMembersResource(dio),
        products = SellerProductsResource(dio);

  final SellerAuthResource auth;
  final SellerSellersResource sellers;
  final SellerTeamResource team;
  final SellerMembersResource members;
  final SellerProductsResource products;

  Future<TokenRes> login(LoginReq body) => auth.login(body);
}
