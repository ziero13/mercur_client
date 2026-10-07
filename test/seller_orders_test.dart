import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

Dio stubOrdersDio({
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
  group('SellerOrdersResource', () {
    test('list hits GET /vendor/orders (empty seed)', () async {
      RequestOptions? captured;
      final resource = SellerOrdersResource(
        stubOrdersDio(
          respond: (options) {
            expect(options.method, equals('GET'));
            expect(options.path, equals('/vendor/orders'));
            return {'orders': [], 'count': 0, 'offset': 0, 'limit': 50};
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list(const SellerListOrdersParams());
      expect(captured?.method, equals('GET'));
      expect(res.count, equals(0));
      expect(res.orders, isEmpty);
    });

    test('retrieve parses doc-shaped order', () async {
      final resource = SellerOrdersResource(
        stubOrdersDio(
          respond: (_) => {
            'order': {
              'id': 'order_01',
              'display_id': 1001,
              'status': 'pending',
              'email': 'buyer@test.dev',
              'currency_code': 'eur',
              'items': [
                {'id': 'ordli_01', 'title': 'Runner 42', 'quantity': 1},
              ],
              'shipping_address': {'city': 'Berlin', 'country_code': 'de'},
              'summary': {'subtotal': 9900, 'total': 9900},
            },
          },
          onRequest: (_) {},
        ),
      );

      final res = await resource.retrieve('order_01');
      expect(res.order.displayId, equals(1001));
      expect(res.order.items.first.title, equals('Runner 42'));
      expect(res.order.shippingAddress?.city, equals('Berlin'));
      expect(res.order.summary?.total, equals(9900));
    });

    test('createFulfillment POSTs items + location', () async {
      RequestOptions? captured;
      final resource = SellerOrdersResource(
        stubOrdersDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path,
                equals('/vendor/orders/order_01/fulfillments'));
            return {
              'fulfillment': {
                'id': 'ful_01',
                'location_id': 'sloc_01',
                'requires_shipping': true,
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.createFulfillment(
        'order_01',
        SellerCreateFulfillmentReq(
          items: const [SellerFulfillmentItem(id: 'ordli_01', quantity: 1)],
          requiresShipping: true,
          locationId: 'sloc_01',
        ),
      );
      expect(captured?.method, equals('POST'));
      expect(res.fulfillment.locationId, equals('sloc_01'));
    });

    test('commissionLines + changes parse doc shapes', () async {
      final resource = SellerOrdersResource(
        stubOrdersDio(
          respond: (options) {
            if (options.path.endsWith('commission-lines')) {
              return {
                'commission_lines': [
                  {
                    'id': 'cl_01',
                    'code': 'DEFAULT',
                    'rate': 0.1,
                    'amount': 990,
                  },
                ],
                'count': 1,
              };
            }
            return {
              'order_changes': [
                {'id': 'chg_01', 'order_id': 'order_01', 'status': 'pending'},
              ],
            };
          },
          onRequest: (_) {},
        ),
      );

      final commissions = await resource.commissionLines('order_01');
      expect(commissions.commissions.first.amount, equals(990));
      final changes = await resource.changes('order_01');
      expect(changes.changes.first.status, equals('pending'));
    });
  });
}
