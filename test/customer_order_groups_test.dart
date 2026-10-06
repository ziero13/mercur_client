import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

import 'resources_test.dart' show stubDio;

void main() {
  group('OrderGroup models', () {
    test('round-trip with child orders + items', () {
      const group = OrderGroup(
        id: 'og_01',
        customerId: 'cus_01',
        sellerCount: 2,
        total: 9900,
        orders: [
          OrderGroupOrder(
            id: 'order_01',
            sellerId: 'sel_01',
            items: [
              OrderGroupOrderItem(id: 'ordli_01', title: 'M', quantity: 1),
            ],
          ),
        ],
      );
      final back = OrderGroup.fromJson(group.toJson());
      expect(back.toJson(), equals(group.toJson()));
      expect(back.orders.first.items.first.title, equals('M'));
    });

    test('partial fields: only id required', () {
      final back = OrderGroup.fromJson(const {'id': 'og_01'});
      expect(back.orders, isEmpty);
      expect(back.total, isNull);
    });

    test('list params default to restricted fields', () {
      const params = CustomerListOrderGroupsParams(limit: 10);
      final q = params.toQuery();
      expect(
        q['fields'],
        equals(orderGroupRestrictedFields.join(',')),
      );
      final back = CustomerListOrderGroupsParams.fromJson(params.toJson());
      expect(back.toQuery(), equals(q));
    });
  });

  group('CustomerOrderGroupsResource', () {
    test('list sends restricted fields by default', () async {
      RequestOptions? captured;
      final resource = CustomerOrderGroupsResource(
        stubDio(
          payload: {
            'order_groups': [
              {
                'id': 'og_01',
                'customer_id': 'cus_01',
                'seller_count': 1,
                'total': 4500,
              },
            ],
            'count': 1,
            'offset': 0,
            'limit': 50,
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list();
      expect(captured?.path, equals('/store/order-groups'));
      expect(
        captured?.queryParameters['fields'],
        equals(orderGroupRestrictedFields.join(',')),
      );
      expect(res.orderGroups.first.total, equals(4500));
    });

    test('retrieve hits /store/order-groups/:id', () async {
      RequestOptions? captured;
      final resource = CustomerOrderGroupsResource(
        stubDio(
          payload: {
            'order_group': {'id': 'og_01', 'seller_count': 2},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.retrieve('og_01');
      expect(captured?.path, equals('/store/order-groups/og_01'));
      expect(
        captured?.queryParameters['fields'],
        equals(orderGroupRestrictedFields.join(',')),
      );
      expect(res.orderGroup.sellerCount, equals(2));
    });
  });
}
