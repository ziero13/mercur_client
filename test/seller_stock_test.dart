import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

Dio stubStockDio({
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
  group('SellerStockResource', () {
    test('item create → retrieve → delete cycle', () async {
      RequestOptions? captured;
      var deleted = false;
      final resource = SellerStockResource(
        stubStockDio(
          respond: (options) {
            if (options.method == 'DELETE') {
              deleted = true;
              return {
                'id': 'iitem_01',
                'object': 'inventory_item',
                'deleted': true,
              };
            }
            return {
              'inventory_item': {
                'id': 'iitem_01',
                'sku': 'TMP-PROBE-01',
                'title': 'Probe',
                'stocked_quantity': 10,
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final created = await resource.createItem(
        const SellerInventoryItemReq(sku: 'TMP-PROBE-01', title: 'Probe'),
      );
      expect(captured?.method, equals('POST'));
      expect(captured?.path, equals('/vendor/inventory-items'));
      expect(created.item.stockedQuantity, equals(10));

      final retrieved = await resource.retrieveItem('iitem_01');
      expect(retrieved.item.sku, equals('TMP-PROBE-01'));

      final del = await resource.deleteItem('iitem_01');
      expect(deleted, isTrue);
      expect(del.deleted, isTrue);
    });

    test('location-levels list uses inventory_levels key', () async {
      final resource = SellerStockResource(
        stubStockDio(
          respond: (_) => {
            'inventory_levels': [],
            'count': 0,
            'offset': 0,
            'limit': 50,
          },
          onRequest: (_) {},
        ),
      );

      final res = await resource.listLevels('iitem_01');
      expect(res.levels, isEmpty);
      expect(res.count, equals(0));
    });

    test('reservations list parses empty seed', () async {
      RequestOptions? captured;
      final resource = SellerStockResource(
        stubStockDio(
          respond: (options) {
            expect(options.path, equals('/vendor/reservations'));
            return {'reservations': [], 'count': 0, 'offset': 0, 'limit': 50};
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.listReservations();
      expect(captured?.method, equals('GET'));
      expect(res.reservations, isEmpty);
    });

    test('stock location retrieve parses live shape', () async {
      final resource = SellerStockResource(
        stubStockDio(
          respond: (_) => {
            'stock_location': {
              'id': 'sloc_01',
              'name': 'Sole Society Warehouse',
            },
          },
          onRequest: (_) {},
        ),
      );

      final res = await resource.retrieveLocation('sloc_01');
      expect(res.location.name, equals('Sole Society Warehouse'));
    });
  });

  group('SellerShippingResource', () {
    test('options list + retrieve parse live shapes', () async {
      RequestOptions? captured;
      final resource = SellerShippingResource(
        stubStockDio(
          respond: (options) {
            if (options.path == '/vendor/shipping-options') {
              return {
                'shipping_options': [
                  {
                    'id': 'so_01',
                    'name': 'Standard Shipping',
                    'price_type': 'flat',
                    'provider_id': 'manual_manual',
                  },
                ],
                'count': 1,
                'offset': 0,
                'limit': 50,
              };
            }
            return {
              'shipping_option': {
                'id': 'so_01',
                'name': 'Standard Shipping',
                'price_type': 'flat',
                'provider_id': 'manual_manual',
                'service_zone_id': 'sz_01',
                'shipping_profile_id': 'sp_01',
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final listed = await resource.listOptions();
      expect(listed.options.first.priceType, equals('flat'));
      final retrieved = await resource.retrieveOption('so_01');
      expect(captured?.path, equals('/vendor/shipping-options/so_01'));
      expect(retrieved.option.serviceZoneId, equals('sz_01'));
    });

    test('profiles list parses live shape', () async {
      final resource = SellerShippingResource(
        stubStockDio(
          respond: (_) => {
            'shipping_profiles': [
              {'id': 'sp_01', 'name': 'Default Shipping Profile'},
            ],
            'count': 2,
            'offset': 0,
            'limit': 50,
          },
          onRequest: (_) {},
        ),
      );

      final res = await resource.listProfiles();
      expect(res.profiles.first.id, equals('sp_01'));
    });
  });
}
