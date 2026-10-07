import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

/// Stubs Dio at the interceptor level, branching on method AND path —
/// POST create and GET list share `/vendor/sellers`, so a suffix-only
/// branch would answer creates with list payloads.
Dio stubSellerDio({
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
  group('SellerSellersResource', () {
    test('list hits GET /vendor/sellers (memberships)', () async {
      RequestOptions? captured;
      final resource = SellerSellersResource(
        stubSellerDio(
          respond: (options) {
            expect(options.method, equals('GET'));
            expect(options.path, equals('/vendor/sellers'));
            return {
              'seller_members': [
                {
                  'id': 'selmem_01',
                  'seller_id': 'sel_01',
                  'role_id': 'role_admin',
                  'seller': {
                    'id': 'sel_01',
                    'name': 'Kickz',
                    'handle': 'kickz',
                    'status': 'open',
                  },
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

      final res = await resource.list(const SellerListMembershipsParams());
      expect(captured?.method, equals('GET'));
      expect(captured?.path, equals('/vendor/sellers'));
      expect(res.count, equals(1));
      expect(res.sellerMembers.first.seller?.handle, equals('kickz'));
      expect(res.sellerMembers.first.sellerId, equals('sel_01'));
      expect(res.sellerMembers.first.roleId, equals('role_admin'));
    });

    test('select POSTs /vendor/sellers/select and scopes the facade',
        () async {
      RequestOptions? captured;
      String? scoped;
      final resource = SellerSellersResource(
        stubSellerDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path, equals('/vendor/sellers/select'));
            return {'success': true, 'seller_id': 'sel_01'};
          },
          onRequest: (options) => captured = options,
        ),
        onSellerSelected: (id) => scoped = id,
      );

      final res = await resource.select(
        const SellerSelectReq(sellerId: 'sel_01'),
      );
      expect(captured?.method, equals('POST'));
      expect(captured?.path, equals('/vendor/sellers/select'));
      expect(res.success, isTrue);
      expect(res.sellerId, equals('sel_01'));
      expect(scoped, equals('sel_01'));
    });

    test('retrieveCurrent hits GET /vendor/sellers/me', () async {
      RequestOptions? captured;
      final resource = SellerSellersResource(
        stubSellerDio(
          respond: (options) {
            expect(options.method, equals('GET'));
            expect(options.path, equals('/vendor/sellers/me'));
            return {
              'seller': {
                'id': 'sel_01',
                'name': 'Kickz',
                'handle': 'kickz',
                'email': 'store@kickz.test',
                'status': 'open',
                'currency_code': 'usd',
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.retrieveCurrent();
      expect(captured?.path, equals('/vendor/sellers/me'));
      expect(res.seller.id, equals('sel_01'));
      expect(res.seller.currencyCode, equals('usd'));
    });

    test('updateCurrent POSTs /vendor/sellers/me', () async {
      RequestOptions? captured;
      final resource = SellerSellersResource(
        stubSellerDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path, equals('/vendor/sellers/me'));
            return {
              'seller': {
                'id': 'sel_01',
                'name': 'Kickz',
                'handle': 'kickz',
                'description': 'Handmade goods.',
                'status': 'open',
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.updateCurrent(
        const SellerUpdateCurrentReq(description: 'Handmade goods.'),
      );
      expect(captured?.method, equals('POST'));
      expect(captured?.path, equals('/vendor/sellers/me'));
      expect(res.seller.description, equals('Handmade goods.'));
    });

    test('create POSTs /vendor/sellers', () async {
      RequestOptions? captured;
      final resource = SellerSellersResource(
        stubSellerDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path, equals('/vendor/sellers'));
            return {
              'seller': {
                'id': 'sel_02',
                'name': 'Acme',
                'handle': 'acme',
                'email': 'store@acme.test',
                'status': 'pending_approval',
                'currency_code': 'usd',
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.create(
        const SellerCreateReq(
          name: 'Acme',
          email: 'store@acme.test',
          currencyCode: 'usd',
        ),
      );
      expect(captured?.method, equals('POST'));
      expect(captured?.path, equals('/vendor/sellers'));
      expect(res.seller.id, equals('sel_02'));
    });
  });
}
