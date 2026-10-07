import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

import 'resources_test.dart' show stubDio;

void main() {
  group('Catalog models', () {
    test('category + option round-trip', () {
      const cat = CustomerCategory(
        id: 'pcat_01',
        name: 'Sandals',
        handle: 'sandals',
      );
      expect(
        CustomerCategory.fromJson(cat.toJson()).handle,
        equals('sandals'),
      );

      const opt = CustomerProductOption(
        id: 'opt_01',
        title: 'Size',
        values: [CustomerProductOptionValue(id: 'v_01', value: '41')],
      );
      final back = CustomerProductOption.fromJson(opt.toJson());
      expect(back.values.single.value, equals('41'));
    });
  });

  group('CustomerCatalogResource', () {
    test('all seven lists hit their paths', () async {
      final paths = <String>[];
      final payloads = <String, Map<String, dynamic>>{
        '/store/collections': {
          'collections': [],
          'count': 0,
          'offset': 0,
          'limit': 1,
        },
        '/store/product-categories': {
          'product_categories': [
            {'id': 'pcat_01', 'name': 'Sandals'},
          ],
          'count': 1,
          'offset': 0,
          'limit': 1,
        },
        '/store/product-tags': {
          'product_tags': [],
          'count': 0,
          'offset': 0,
          'limit': 1,
        },
        '/store/product-types': {
          'product_types': [],
          'count': 0,
          'offset': 0,
          'limit': 1,
        },
        '/store/product-attributes': {
          'product_attributes': [
            {'id': 'pattr_01', 'name': 'Size'},
          ],
          'count': 1,
          'offset': 0,
          'limit': 1,
        },
        '/store/product-options': {
          'product_options': [
            {'id': 'opt_01', 'title': 'Size', 'values': []},
          ],
          'count': 1,
          'offset': 0,
          'limit': 1,
        },
        '/store/product-variants': {
          'product_variants': [
            {'id': 'var_01', 'sku': 'SKU-1'},
          ],
          'count': 1,
          'offset': 0,
          'limit': 1,
        },
      };
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            paths.add(options.path);
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: payloads[options.path] ?? {'count': 0},
              ),
            );
          },
        ),
      );
      final resource = CustomerCatalogResource(dio);
      const q = CustomerCatalogListParams(limit: 1);

      final cats = await resource.listCategories(q);
      expect(cats.records.single.name, equals('Sandals'));
      final attrs = await resource.listAttributes(q);
      expect(attrs.records.single.name, equals('Size'));
      final opts = await resource.listOptions(q);
      expect(opts.records.single.title, equals('Size'));
      final vars = await resource.listVariants(q);
      expect(vars.records.single.sku, equals('SKU-1'));
      await resource.listCollections(q);
      await resource.listTags(q);
      await resource.listTypes(q);

      expect(
        paths,
        equals([
          '/store/product-categories',
          '/store/product-attributes',
          '/store/product-options',
          '/store/product-variants',
          '/store/collections',
          '/store/product-tags',
          '/store/product-types',
        ]),
      );
    });

    test('retrieve hits detail paths', () async {
      RequestOptions? captured;
      final resource = CustomerCatalogResource(
        stubDio(
          payload: {
            'product_category': {'id': 'pcat_01', 'name': 'Sandals'},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.retrieveCategory('pcat_01');
      expect(captured?.path, equals('/store/product-categories/pcat_01'));
      expect(res.category.name, equals('Sandals'));
    });
  });
}
