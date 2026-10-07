import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

Dio stubCatalogDio({
  required Map<String, dynamic> Function(RequestOptions options) respond,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
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
  group('SellerCatalogResource', () {
    test('categories parse live shape', () async {
      RequestOptions? captured;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'product_categories': [
                    {
                      'id': 'pcat_01',
                      'name': 'Sandals',
                      'handle': 'sandals',
                      'is_active': true,
                    },
                  ],
                  'count': 1,
                  'offset': 0,
                  'limit': 50,
                },
              ),
            );
          },
        ),
      );
      final resource = SellerCatalogResource(dio);

      final res = await resource.categories();
      expect(captured?.path, equals('/vendor/product-categories'));
      expect(res.records.first.name, equals('Sandals'));
      expect(res.count, equals(1));
    });

    test('attributes parse live shape', () async {
      final resource = SellerCatalogResource(
        stubCatalogDio(
          respond: (_) => {
            'product_attributes': [
              {
                'id': 'pattr_01',
                'name': 'Size',
                'handle': 'size',
                'type': 'multi_select',
                'is_variant_axis': true,
              },
            ],
            'count': 1,
            'offset': 0,
            'limit': 50,
          },
        ),
      );

      final res = await resource.attributes();
      expect(res.records.first.isVariantAxis, isTrue);
    });

    test('tags empty seed', () async {
      final resource = SellerCatalogResource(
        stubCatalogDio(
          respond: (_) => {
            'product_tags': [],
            'count': 0,
            'offset': 0,
            'limit': 50,
          },
        ),
      );

      final res = await resource.tags();
      expect(res.records, isEmpty);
    });
  });

  group('SellerMiscResource', () {
    test('regions, currencies, stores, flags parse live shapes', () async {
      RequestOptions? captured;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            final path = options.path;
            final data = path.endsWith('regions')
                ? {
                    'regions': [
                      {
                        'id': 'reg_01',
                        'name': 'Europe',
                        'currency_code': 'eur',
                      },
                    ],
                    'count': 1,
                    'offset': 0,
                    'limit': 50,
                  }
                : path.endsWith('currencies')
                    ? {
                        'currencies': [
                          {'code': 'eur', 'name': 'Euro', 'symbol': '€'},
                        ],
                        'count': 126,
                        'offset': 0,
                        'limit': 50,
                      }
                    : path.endsWith('stores')
                        ? {
                            'stores': [
                              {
                                'id': 'store_01',
                                'name': 'Mercur Marketplace',
                              },
                            ],
                            'count': 1,
                            'offset': 0,
                            'limit': 50,
                          }
                        : {
                            'feature_flags': {
                              'seller_registration': true,
                              'product_request': true,
                            },
                          };
            handler.resolve(
              Response(
                  requestOptions: options, statusCode: 200, data: data),
            );
          },
        ),
      );
      final resource = SellerMiscResource(dio);

      final regions = await resource.regions();
      expect(captured?.path, equals('/vendor/regions'));
      expect(regions.records.first.currencyCode, equals('eur'));
      final currencies = await resource.currencies();
      expect(currencies.records.first.code, equals('eur'));
      final stores = await resource.stores();
      expect(stores.records.first.name, equals('Mercur Marketplace'));
      final flags = await resource.featureFlags();
      expect(flags['seller_registration'], isTrue);
    });
  });
}
