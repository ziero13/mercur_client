import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

Dio stubProductsDio({
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
  group('SellerProductsResource', () {
    test('list hits GET /vendor/products with filters', () async {
      RequestOptions? captured;
      final resource = SellerProductsResource(
        stubProductsDio(
          respond: (options) {
            expect(options.method, equals('GET'));
            expect(options.path, equals('/vendor/products'));
            return {
              'products': [
                {
                  'id': 'prod_01',
                  'title': 'Runner',
                  'handle': 'runner',
                  'status': 'published',
                  'variants': [
                    {'id': 'var_01', 'title': '42', 'sku': 'RUN-42'},
                  ],
                },
              ],
              'count': 1,
              'offset': 0,
              'limit': 20,
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list(
        const SellerListProductsParams(limit: 20, status: ['published']),
      );
      expect(captured?.method, equals('GET'));
      expect(captured?.queryParameters['limit'], equals(20));
      expect(res.products.first.variants.first.sku, equals('RUN-42'));
    });

    test('create POSTs /vendor/products', () async {
      RequestOptions? captured;
      final resource = SellerProductsResource(
        stubProductsDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path, equals('/vendor/products'));
            return {
              'product': {
                'id': 'prod_02',
                'title': 'New Shoe',
                'handle': 'new-shoe',
                'status': 'proposed',
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.create(
        const SellerCreateProductReq(title: 'New Shoe'),
      );
      expect(captured?.method, equals('POST'));
      expect(res.product.status, equals('proposed'));
    });

    test('update stages a product_change', () async {
      RequestOptions? captured;
      final resource = SellerProductsResource(
        stubProductsDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path, equals('/vendor/products/prod_01'));
            return {
              'product_change': {
                'id': 'pch_01',
                'product_id': 'prod_01',
                'status': 'pending',
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.update(
        'prod_01',
        const SellerUpdateProductReq(description: 'New desc'),
      );
      expect(captured?.path, equals('/vendor/products/prod_01'));
      expect(res.change?.status, equals('pending'));
    });

    test('preview returns null change when clean', () async {
      final resource = SellerProductsResource(
        stubProductsDio(
          respond: (_) => {'product_change': null},
          onRequest: (_) {},
        ),
      );

      final res = await resource.preview('prod_01');
      expect(res.change, isNull);
    });

    test('listVariants + createVariant branch on method AND path', () async {
      RequestOptions? captured;
      final resource = SellerProductsResource(
        stubProductsDio(
          respond: (options) {
            if (options.method == 'GET') {
              return {
                'variants': [
                  {'id': 'var_01', 'title': '42', 'sku': 'RUN-42'},
                ],
                'count': 1,
                'offset': 0,
                'limit': 50,
              };
            }
            return {
              'product_change': {
                'id': 'pch_02',
                'product_id': 'prod_01',
                'status': 'pending',
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final listed = await resource.listVariants('prod_01');
      expect(listed.variants.first.id, equals('var_01'));
      final staged = await resource.createVariant(
        'prod_01',
        const SellerVariantReq(title: '43', sku: 'RUN-43'),
      );
      expect(captured?.method, equals('POST'));
      expect(staged.change?.id, equals('pch_02'));
    });
  });
}
