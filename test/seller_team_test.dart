import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

/// Stub branching on method AND path.
Dio stubTeamDio({
  required Map<String, dynamic> Function(RequestOptions options) respond,
  required void Function(RequestOptions options) onRequest,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        onRequest(options);
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: respond(options),
          ),
        );
      },
    ),
  );
  return dio;
}

void main() {
  group('SellerTeamResource', () {
    test('listMembers hits GET /vendor/sellers/:id/members', () async {
      RequestOptions? captured;
      final resource = SellerTeamResource(
        stubTeamDio(
          respond: (options) {
            expect(options.method, equals('GET'));
            expect(
              options.path,
              equals('/vendor/sellers/sel_01/members'),
            );
            return {
              'seller_members': [
                {
                  'id': 'selmem_01',
                  'is_owner': true,
                  'member': {
                    'id': 'mem_01',
                    'first_name': 'Demo',
                    'email': 'seller@mercur.dev',
                  },
                  'role_id': 'role_seller_administration',
                  'created_at': '2026-01-15T10:00:00.000Z',
                },
              ],
              'count': 1,
              'offset': 0,
              'limit': 50,
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.listMembers('sel_01');
      expect(captured?.method, equals('GET'));
      expect(res.count, equals(1));
      expect(res.sellerMembers.first.isOwner, isTrue);
      expect(res.sellerMembers.first.member?.email,
          equals('seller@mercur.dev'));
    });

    test('inviteMember POSTs and returns member_invite', () async {
      RequestOptions? captured;
      final resource = SellerTeamResource(
        stubTeamDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(
              options.path,
              equals('/vendor/sellers/sel_01/members'),
            );
            return {
              'member_invite': {
                'id': 'meminv_01',
                'email': 'teammate@acme.test',
                'role_id': 'role_seller_order_management',
                'accepted': false,
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.inviteMember(
        'sel_01',
        const SellerInviteMemberReq(
          email: 'teammate@acme.test',
          roleId: 'role_seller_order_management',
        ),
      );
      expect(captured?.method, equals('POST'));
      expect(res.invite.accepted, isFalse);
      expect(res.invite.roleId,
          equals('role_seller_order_management'));
    });

    test('upsertAddress POSTs /vendor/sellers/:id/address', () async {
      RequestOptions? captured;
      final resource = SellerTeamResource(
        stubTeamDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(
              options.path,
              equals('/vendor/sellers/sel_01/address'),
            );
            return {
              'seller': {
                'id': 'sel_01',
                'name': 'Kickz',
                'handle': 'kickz',
                'address': {'city': 'Berlin', 'country_code': 'de'},
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.upsertAddress(
        'sel_01',
        const SellerAddressReq(city: 'Berlin', countryCode: 'de'),
      );
      expect(captured?.method, equals('POST'));
      expect(res.seller.address?.city, equals('Berlin'));
    });

    test('upsert + delete professional-details round-trip', () async {
      var deleted = false;
      final resource = SellerTeamResource(
        stubTeamDio(
          respond: (options) {
            if (options.method == 'POST') {
              return {
                'seller': {
                  'id': 'sel_01',
                  'name': 'Kickz',
                  'handle': 'kickz',
                  'professional_details': {
                    'corporate_name': 'Kickz GmbH',
                    'tax_id': 'DE123',
                  },
                },
              };
            }
            deleted = true;
            return {
              'seller': {
                'id': 'sel_01',
                'name': 'Kickz',
                'handle': 'kickz',
                'professional_details': null,
              },
            };
          },
          onRequest: (_) {},
        ),
      );

      final upserted = await resource.upsertProfessionalDetails(
        'sel_01',
        const SellerProfessionalDetailsReq(
          corporateName: 'Kickz GmbH',
          taxId: 'DE123',
        ),
      );
      expect(upserted.seller.professionalDetails?.corporateName,
          equals('Kickz GmbH'));
      final cleared = await resource.deleteProfessionalDetails('sel_01');
      expect(deleted, isTrue);
      expect(cleared.seller.professionalDetails, isNull);
    });

    test('removeMember DELETEs and returns confirmation', () async {
      RequestOptions? captured;
      final resource = SellerTeamResource(
        stubTeamDio(
          respond: (options) {
            expect(options.method, equals('DELETE'));
            return {
              'id': 'selmem_09',
              'object': 'seller_member',
              'deleted': true,
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.removeMember('sel_01', 'selmem_09');
      expect(
        captured?.path,
        equals('/vendor/sellers/sel_01/members/selmem_09'),
      );
      expect(res.deleted, isTrue);
    });
  });

  group('SellerMembersResource', () {
    test('retrieveMe hits GET /vendor/members/me', () async {
      RequestOptions? captured;
      final resource = SellerMembersResource(
        stubTeamDio(
          respond: (options) {
            expect(options.method, equals('GET'));
            expect(options.path, equals('/vendor/members/me'));
            return {
              'seller_member': {
                'id': 'selmem_01',
                'is_owner': true,
                'member': {'id': 'mem_01', 'email': 'seller@mercur.dev'},
                'seller': {'id': 'sel_01', 'name': 'Kickz', 'handle': 'kickz'},
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.retrieveMe();
      expect(captured?.path, equals('/vendor/members/me'));
      expect(res.sellerMember.seller?.id, equals('sel_01'));
    });

    test('acceptInvite POSTs public route', () async {
      RequestOptions? captured;
      final resource = SellerMembersResource(
        stubTeamDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path,
                equals('/vendor/members/invites/accept'));
            return {
              'member': {'id': 'mem_02', 'email': 'teammate@acme.test'},
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.acceptInvite(
        const MemberAcceptInviteReq(inviteToken: 'tok_123'),
      );
      expect(captured?.method, equals('POST'));
      expect(res.member.id, equals('mem_02'));
    });
  });
}
