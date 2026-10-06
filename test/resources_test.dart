import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

/// Stubs Dio at the interceptor level: captures the outgoing request and
/// returns a canned payload — no network, no extra dependencies.
Dio stubDio({
  required Map<String, dynamic> payload,
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
            data: payload,
          ),
        );
      },
    ),
  );
  return dio;
}

void main() {
  group('CustomerProductsResource', () {
    test('list hits /store/products with serialised query', () async {
      RequestOptions? captured;
      final resource = CustomerProductsResource(
        stubDio(
          payload: {
            'products': [
              {
                'id': 'prod_01',
                'title': 'Linen Shirt',
                'handle': 'linen-shirt',
                'status': 'published',
              },
            ],
            'count': 1,
            'offset': 0,
            'limit': 10,
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list(
        const CustomerListProductsParams(limit: 10, q: 'linen'),
      );

      expect(captured?.path, equals('/store/products'));
      expect(captured?.queryParameters['limit'], equals(10));
      expect(captured?.queryParameters['q'], equals('linen'));
      expect(res.count, equals(1));
      expect(res.products.first.title, equals('Linen Shirt'));
    });

    test('retrieve hits /store/products/:id', () async {
      RequestOptions? captured;
      final resource = CustomerProductsResource(
        stubDio(
          payload: {
            'product': {
              'id': 'prod_01',
              'title': 'Linen Shirt',
              'handle': 'linen-shirt',
              'status': 'published',
            },
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.retrieve('prod_01');
      expect(captured?.path, equals('/store/products/prod_01'));
      expect(res.product.id, equals('prod_01'));
    });
  });

  group('CustomerSellersResource', () {
    test('list hits /store/sellers', () async {
      RequestOptions? captured;
      final resource = CustomerSellersResource(
        stubDio(
          payload: {
            'sellers': [
              {'id': 'sel_01', 'name': 'Kickz', 'handle': 'kickz'},
            ],
            'count': 1,
            'offset': 0,
            'limit': 50,
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list(const CustomerListSellersParams());
      expect(captured?.path, equals('/store/sellers'));
      expect(res.sellers.first.handle, equals('kickz'));
    });
  });

  group('Mercur facade', () {
    test('store dio carries publishable key, customer token opt-in', () async {
      final mercur = Mercur(
        const Configuration(
          baseUrl: 'http://localhost:9000',
          publishableKey: 'pk_test',
        ),
      );

      RequestOptions? captured;
      mercur.customerDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'products': [], 'count': 0, 'offset': 0, 'limit': 0},
              ),
            );
          },
        ),
      );

      await mercur.customer.products.list();
      expect(
        captured?.headers['x-publishable-api-key'],
        equals('pk_test'),
      );
      expect(captured?.headers['Authorization'], isNull);

      mercur.setCustomerToken('cust_tok');
      await mercur.customer.products.list();
      expect(
        captured?.headers['Authorization'],
        equals('Bearer cust_tok'),
      );
    });
  });
}
