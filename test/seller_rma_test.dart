import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

Dio stubRmaDio({
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
  group('SellerOrderEditsResource', () {
    test('create POSTs /vendor/order-edits', () async {
      RequestOptions? captured;
      final resource = SellerOrderEditsResource(
        stubRmaDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path, equals('/vendor/order-edits'));
            return {
              'order_change': {
                'id': 'ordch_01',
                'order_id': 'order_01',
                'status': 'pending',
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final change = await resource.create(
        const OrderEditCreateReq(orderId: 'order_01'),
      );
      expect(captured?.method, equals('POST'));
      expect(change.id, equals('ordch_01'));
      expect(change.status, equals('pending'));
    });

    test('addItems + request + confirm chain paths', () async {
      final seen = <String>[];
      final resource = SellerOrderEditsResource(
        stubRmaDio(
          respond: (options) {
            seen.add('${options.method} ${options.path}');
            if (options.path.endsWith('/request') ||
                options.path.endsWith('/confirm')) {
              return {
                'order_preview': {'id': 'order_01', 'status': 'pending'},
              };
            }
            return {
              'order_change': {
                'id': 'ordch_01',
                'order_id': 'order_01',
                'status': 'pending',
              },
            };
          },
          onRequest: (_) {},
        ),
      );

      final staged = await resource.addItems(
        'ordch_01',
        OrderEditAddItemsReq(
          items: const [
            RmaAddItem(offerId: 'offer_01', quantity: 1),
          ],
        ),
      );
      expect(staged.orderChange?.id, equals('ordch_01'));
      final requested = await resource.request('ordch_01');
      expect(requested.orderPreview?.id, equals('order_01'));
      final confirmed = await resource.confirm('ordch_01');
      expect(confirmed.orderPreview?.status, equals('pending'));
      expect(
        seen,
        equals([
          'POST /vendor/order-edits/ordch_01/items',
          'POST /vendor/order-edits/ordch_01/request',
          'POST /vendor/order-edits/ordch_01/confirm',
        ]),
      );
    });

    test('cancel DELETEs the staged edit', () async {
      RequestOptions? captured;
      final resource = SellerOrderEditsResource(
        stubRmaDio(
          respond: (_) => {
            'id': 'ordch_01',
            'object': 'order-edit',
            'deleted': true,
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.cancel('order_01');
      expect(captured?.method, equals('DELETE'));
      expect(captured?.path, equals('/vendor/order-edits/order_01'));
      expect(res.deleted, isTrue);
    });
  });

  group('SellerReturnsResource', () {
    test('list + create ({order, return}) + retrieve', () async {
      final resource = SellerReturnsResource(
        stubRmaDio(
          respond: (options) {
            if (options.method == 'GET' &&
                options.path == '/vendor/returns') {
              return {'returns': [], 'count': 0, 'offset': 0, 'limit': 50};
            }
            if (options.method == 'POST' &&
                options.path == '/vendor/returns') {
              return {
                'order': {'id': 'order_01', 'status': 'pending'},
                'return': {
                  'id': 'ret_01',
                  'order_id': 'order_01',
                  'status': 'requested',
                },
              };
            }
            return {
              'return': {
                'id': 'ret_01',
                'order_id': 'order_01',
                'status': 'requested',
              },
            };
          },
          onRequest: (_) {},
        ),
      );

      final listed = await resource.list();
      expect(listed.count, equals(0));
      final created = await resource.create(
        const ReturnCreateReq(orderId: 'order_01'),
      );
      expect(created.ret?.id, equals('ret_01'));
      expect(created.order?.id, equals('order_01'));
      final detail = await resource.retrieve('ret_01');
      expect(detail.ret.status, equals('requested'));
    });

    test('receive flow paths', () async {
      final seen = <String>[];
      final resource = SellerReturnsResource(
        stubRmaDio(
          respond: (options) {
            seen.add('${options.method} ${options.path}');
            return {
              'order_preview': {'id': 'order_01', 'status': 'pending'},
              'return': {'id': 'ret_01', 'status': 'received'},
            };
          },
          onRequest: (_) {},
        ),
      );

      await resource.startReceive(
        'ret_01',
        const ReturnReceiveReq(description: 'box arrived'),
      );
      await resource.receiveItems(
        'ret_01',
        ReturnReceiveItemsReq(
          items: const [RmaReceiveItem(id: 'ordli_01', quantity: 1)],
        ),
      );
      final done = await resource.confirmReceive('ret_01');
      expect(done.ret?.status, equals('received'));
      expect(
        seen,
        equals([
          'POST /vendor/returns/ret_01/receive',
          'POST /vendor/returns/ret_01/receive-items',
          'POST /vendor/returns/ret_01/receive/confirm',
        ]),
      );
    });
  });

  group('SellerClaimsResource', () {
    test('create returns id ref, request returns preview', () async {
      final resource = SellerClaimsResource(
        stubRmaDio(
          respond: (options) {
            if (options.method == 'POST' && options.path == '/vendor/claims') {
              return {
                'claim': {'id': 'claim_01'},
              };
            }
            return {
              'order_preview': {'id': 'order_01', 'status': 'pending'},
            };
          },
          onRequest: (_) {},
        ),
      );

      final created = await resource.create(
        const ClaimCreateReq(type: 'refund', orderId: 'order_01'),
      );
      expect(created.id, equals('claim_01'));
      final requested = await resource.request('claim_01');
      expect(requested.orderPreview?.id, equals('order_01'));
    });

    test('inbound/outbound mixin paths', () async {
      final seen = <String>[];
      final resource = SellerClaimsResource(
        stubRmaDio(
          respond: (options) {
            seen.add('${options.method} ${options.path}');
            return {'order_preview': {'id': 'order_01'}};
          },
          onRequest: (_) {},
        ),
      );

      await resource.addClaimItems(
        'claim_01',
        ClaimItemsReq(
          items: const [ClaimItem(id: 'ordli_01', quantity: 1)],
        ),
      );
      await resource.addInboundItems(
        'claim_01',
        RmaInboundReq(
          items: const [RmaRequestItem(id: 'ordli_01', quantity: 1)],
        ),
      );
      await resource.addOutboundItems(
        'claim_01',
        RmaOutboundReq(
          items: const [RmaAddItem(offerId: 'offer_01', quantity: 1)],
        ),
      );
      expect(
        seen,
        equals([
          'POST /vendor/claims/claim_01/claim-items',
          'POST /vendor/claims/claim_01/inbound/items',
          'POST /vendor/claims/claim_01/outbound/items',
        ]),
      );
    });

    test('cancel returns the claim', () async {
      final resource = SellerClaimsResource(
        stubRmaDio(
          respond: (_) => {
            'claim': {'id': 'claim_01', 'status': 'canceled'},
          },
          onRequest: (_) {},
        ),
      );

      final res = await resource.cancel('claim_01');
      expect(res.claim.status, equals('canceled'));
    });
  });

  group('SellerExchangesResource', () {
    test('create + request + cancel chain', () async {
      final seen = <String>[];
      final resource = SellerExchangesResource(
        stubRmaDio(
          respond: (options) {
            seen.add('${options.method} ${options.path}');
            if (options.method == 'POST' &&
                options.path == '/vendor/exchanges') {
              return {
                'exchange': {'id': 'exc_01'},
              };
            }
            if (options.path.endsWith('/cancel')) {
              return {
                'exchange': {'id': 'exc_01', 'status': 'canceled'},
              };
            }
            return {
              'order_preview': {'id': 'order_01'},
            };
          },
          onRequest: (_) {},
        ),
      );

      final created = await resource.create(
        const ExchangeCreateReq(orderId: 'order_01'),
      );
      expect(created.id, equals('exc_01'));
      await resource.addInboundItems(
        'exc_01',
        RmaInboundReq(
          items: const [RmaRequestItem(id: 'ordli_01', quantity: 1)],
        ),
      );
      await resource.request('exc_01');
      final canceled = await resource.cancel('exc_01');
      expect(canceled.exchange?.status, equals('canceled'));
      expect(
        seen,
        equals([
          'POST /vendor/exchanges',
          'POST /vendor/exchanges/exc_01/inbound/items',
          'POST /vendor/exchanges/exc_01/request',
          'POST /vendor/exchanges/exc_01/cancel',
        ]),
      );
    });

    test('list parses empty seed', () async {
      RequestOptions? captured;
      final resource = SellerExchangesResource(
        stubRmaDio(
          respond: (_) => {
            'exchanges': [],
            'count': 0,
            'offset': 0,
            'limit': 50,
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list();
      expect(captured?.path, equals('/vendor/exchanges'));
      expect(res.exchanges, isEmpty);
    });
  });
}
