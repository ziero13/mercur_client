import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

import 'resources_test.dart' show stubDio;

void main() {
  group('Admin seller models', () {
    test('create body nests owner email under member', () {
      const body = AdminCreateSellerReq(
        name: 'Acme',
        email: 'hello@acme.co',
        currencyCode: 'usd',
        memberEmail: 'owner@acme.co',
      );
      final json = body.toJson();
      expect((json['member'] as Map)['email'], equals('owner@acme.co'));
      expect(json.containsKey('status'), isFalse);
      final back = AdminCreateSellerReq.fromJson(json);
      expect(back.memberEmail, equals('owner@acme.co'));
    });

    test('update body omits unset fields', () {
      const body = AdminUpdateSellerReq(
        description: 'Handmade goods.',
        isPremium: true,
      );
      expect(body.toJson(), equals({
        'description': 'Handmade goods.',
        'is_premium': true,
      }));
    });

    test('seller decodes admin-only fields', () {
      final seller = Seller.fromJson(const {
        'id': 'sel_01',
        'name': 'Acme',
        'handle': 'acme',
        'status': 'suspended',
        'status_reason': 'Policy violation',
        'external_id': 'ext-1',
      });
      expect(seller.statusReason, equals('Policy violation'));
      expect(seller.externalId, equals('ext-1'));
      final back = Seller.fromJson(seller.toJson());
      expect(back.statusReason, equals('Policy violation'));
    });

    test('list params serialize filters', () {
      const q = AdminListSellersParams(
        status: ['pending_approval'],
        limit: 20,
      );
      final query = q.toQuery();
      expect(query['status'], equals(['pending_approval']));
      expect(query['limit'], equals(20));
    });
  });

  group('AdminSellersResource', () {
    AdminSellersResource resourceFor(
      Map<String, dynamic> payload, {
      required void Function(RequestOptions) onRequest,
    }) => AdminSellersResource(stubDio(payload: payload, onRequest: onRequest));

    test('list + retrieve hit their paths', () async {
      final paths = <String>[];
      RequestOptions? last;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            paths.add(options.path);
            last = options;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: options.path == '/admin/sellers'
                    ? {
                        'sellers': [
                          {'id': 'sel_01', 'status': 'pending_approval'},
                        ],
                        'count': 1,
                        'offset': 0,
                        'limit': 20,
                      }
                    : {
                        'seller': {'id': 'sel_01', 'status': 'open'},
                      },
              ),
            );
          },
        ),
      );
      final resource = AdminSellersResource(dio);

      final list = await resource.list(
        const AdminListSellersParams(status: ['pending_approval'], limit: 20),
      );
      expect(list.sellers.single.id, equals('sel_01'));
      expect(last?.queryParameters['status'], equals(['pending_approval']));

      final one = await resource.retrieve('sel_01');
      expect(one.seller.status, equals('open'));
      expect(paths, equals(['/admin/sellers', '/admin/sellers/sel_01']));
    });

    test('create posts nested member email', () async {
      RequestOptions? captured;
      Map<String, dynamic>? body;
      final resource = resourceFor(
        {
          'seller': {'id': 'sel_02', 'status': 'pending_approval'},
        },
        onRequest: (options) {
          captured = options;
          body = options.data is Map<String, dynamic>
              ? Map<String, dynamic>.from(options.data as Map)
              : null;
        },
      );

      final res = await resource.create(
        const AdminCreateSellerReq(
          name: 'Acme',
          email: 'hello@acme.co',
          currencyCode: 'usd',
          memberEmail: 'owner@acme.co',
        ),
      );
      expect(captured?.path, equals('/admin/sellers'));
      expect(captured?.method, equals('POST'));
      expect((body?['member'] as Map)['email'], equals('owner@acme.co'));
      expect(res.seller.id, equals('sel_02'));
    });

    test('lifecycle posts hit sub-paths', () async {
      final paths = <String>[];
      final bodies = <Object?>[];
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            paths.add(options.path);
            bodies.add(options.data);
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'seller': {'id': 'sel_01', 'status': 'open'},
                },
              ),
            );
          },
        ),
      );
      final resource = AdminSellersResource(dio);

      await resource.approve('sel_01');
      await resource.suspend(
        'sel_01',
        const AdminSellerStatusReasonReq(reason: 'Policy violation'),
      );
      await resource.unsuspend('sel_01');
      await resource.terminate('sel_01');
      await resource.unterminate('sel_01');
      await resource.update(
        'sel_01',
        const AdminUpdateSellerReq(isPremium: true),
      );

      expect(paths, equals([
        '/admin/sellers/sel_01/approve',
        '/admin/sellers/sel_01/suspend',
        '/admin/sellers/sel_01/unsuspend',
        '/admin/sellers/sel_01/terminate',
        '/admin/sellers/sel_01/unterminate',
        '/admin/sellers/sel_01',
      ]));
      expect((bodies[1] as Map)['reason'], equals('Policy violation'));
      expect((bodies[5] as Map)['is_premium'], isTrue);
    });

    test('details upserts + delete hit sub-paths', () async {
      final paths = <String>[];
      final methods = <String?>[];
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            paths.add(options.path);
            methods.add(options.method);
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'seller': {'id': 'sel_01'},
                },
              ),
            );
          },
        ),
      );
      final resource = AdminSellersResource(dio);

      await resource.upsertAddress(
        'sel_01',
        const AdminUpsertSellerAddressReq(city: 'Berlin'),
      );
      await resource.upsertPaymentDetails(
        'sel_01',
        const AdminUpsertSellerPaymentDetailsReq(iban: 'DE00'),
      );
      await resource.upsertProfessionalDetails(
        'sel_01',
        const AdminUpsertSellerProfessionalDetailsReq(taxId: 'DE1'),
      );
      await resource.deleteProfessionalDetails('sel_01');

      expect(paths, equals([
        '/admin/sellers/sel_01/address',
        '/admin/sellers/sel_01/payment-details',
        '/admin/sellers/sel_01/professional-details',
        '/admin/sellers/sel_01/professional-details',
      ]));
      expect(methods, equals(['POST', 'POST', 'POST', 'DELETE']));
    });

    test('team + invites + products hit sub-paths', () async {
      final paths = <String>[];
      final methods = <String?>[];
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            paths.add(options.path);
            methods.add(options.method);
            final p = options.path;
            Object payload;
            if (options.method == 'DELETE') {
              payload = {'id': 'x', 'object': 'seller_member', 'deleted': true};
            } else if (p.endsWith('/members') && options.method == 'GET') {
              payload = {
                'seller_members': [
                  {'id': 'selmem_01', 'is_owner': true},
                ],
                'count': 1,
                'offset': 0,
                'limit': 50,
              };
            } else if (p.endsWith('/members')) {
              payload = {
                'seller_member': {'id': 'selmem_02', 'seller_id': 'sel_01'},
              };
            } else if (p.contains('/invites/') || p.endsWith('/invite')) {
              payload = {
                'member_invite': {'id': 'meminv_01'},
              };
            } else if (p.endsWith('/invites')) {
              payload = {
                'member_invites': [
                  {'id': 'meminv_01'},
                ],
                'count': 1,
                'offset': 0,
                'limit': 50,
              };
            } else if (p.endsWith('/products')) {
              payload = {
                'products': [
                  {'id': 'prod_01', 'title': 'Tote'},
                ],
                'count': 1,
                'offset': 0,
                'limit': 20,
              };
            } else {
              payload = {'id': 'x', 'object': 'seller_member', 'deleted': true};
            }
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: payload,
              ),
            );
          },
        ),
      );
      final resource = AdminSellersResource(dio);

      final members = await resource.listMembers('sel_01');
      expect(members.sellerMembers.single.id, equals('selmem_01'));
      final added = await resource.addMember(
        'sel_01',
        const AdminAddSellerMemberReq(memberId: 'mem_01', roleId: 'role_01'),
      );
      expect(added.sellerMember.id, equals('selmem_02'));
      final removed = await resource.removeMember('sel_01', 'selmem_02');
      expect(removed.deleted, isTrue);
      final invites = await resource.listInvites('sel_01');
      expect(invites.invites.single.id, equals('meminv_01'));
      final invited = await resource.inviteMember(
        'sel_01',
        const AdminInviteSellerMemberReq(
          email: 'n@acme.co',
          roleId: 'role_01',
        ),
      );
      expect(invited.invite.id, equals('meminv_01'));
      final resent = await resource.resendInvite('sel_01', 'meminv_01');
      expect(resent.invite.id, equals('meminv_01'));
      final delInvite = await resource.deleteInvite('sel_01', 'meminv_01');
      expect(delInvite.object, equals('seller_member'));
      final products = await resource.listProducts('sel_01');
      expect(products.products.single.title, equals('Tote'));

      expect(paths, equals([
        '/admin/sellers/sel_01/members',
        '/admin/sellers/sel_01/members',
        '/admin/sellers/sel_01/members/selmem_02',
        '/admin/sellers/sel_01/members/invites',
        '/admin/sellers/sel_01/members/invite',
        '/admin/sellers/sel_01/members/invites/meminv_01/resend',
        '/admin/sellers/sel_01/members/invites/meminv_01',
        '/admin/sellers/sel_01/products',
      ]));
      expect(methods, equals([
        'GET',
        'POST',
        'DELETE',
        'GET',
        'POST',
        'POST',
        'DELETE',
        'GET',
      ]));
    });
  });
}
