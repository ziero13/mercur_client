import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

import 'resources_test.dart' show stubDio;

void main() {
  group('Cart models', () {
    test('line item reads offer_id from metadata', () {
      final item = CustomerCartLineItem.fromJson(const {
        'id': 'cali_01',
        'title': 'M',
        'quantity': 2,
        'unit_price': 4500,
        'metadata': {'offer_id': 'offer_01'},
      });
      expect(item.offerId, equals('offer_01'));
      expect(item.toJson()['metadata'], equals({'offer_id': 'offer_01'}));
    });

    test('CustomerAddLineItemReq uses offer_id', () {
      const req = CustomerAddLineItemReq(offerId: 'offer_01', quantity: 1);
      expect(req.toJson(), equals({'offer_id': 'offer_01', 'quantity': 1}));
      final back = CustomerAddLineItemReq.fromJson(req.toJson());
      expect(back.offerId, equals('offer_01'));
    });

    test('complete response parses order_group branch', () {
      final res = CustomerCompleteCartRes.fromJson(const {
        'type': 'order_group',
        'order_group': {
          'id': 'og_01',
          'seller_count': 2,
          'total': 9000,
        },
      });
      expect(res.type, equals(CompleteCartType.orderGroup));
      expect(res.orderGroup?.sellerCount, equals(2));
    });

    test('complete response parses cart + payment error branch', () {
      final res = CustomerCompleteCartRes.fromJson(const {
        'type': 'cart',
        'cart': {'id': 'cart_01'},
        'error': {
          'message': 'auth needed',
          'type': 'payment_authorization_error',
        },
      });
      expect(res.type, equals(CompleteCartType.cart));
      expect(res.cart?.id, equals('cart_01'));
      expect(res.error?.type, equals('payment_authorization_error'));
    });
  });

  group('CustomerCartsResource', () {
    test('create posts /store/carts with region_id', () async {
      RequestOptions? captured;
      final resource = CustomerCartsResource(
        stubDio(
          payload: {
            'cart': {'id': 'cart_01', 'currency_code': 'eur'},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.create(
        const CustomerCreateCartReq(regionId: 'reg_01'),
      );
      expect(captured?.path, equals('/store/carts'));
      expect(captured?.method, equals('POST'));
      expect(
        (captured?.data as Map)['region_id'],
        equals('reg_01'),
      );
      expect(res.cart.id, equals('cart_01'));
    });

    test('addLineItem posts offer_id body', () async {
      RequestOptions? captured;
      final resource = CustomerCartsResource(
        stubDio(
          payload: {
            'cart': {
              'id': 'cart_01',
              'items': [
                {
                  'id': 'cali_01',
                  'quantity': 1,
                  'metadata': {'offer_id': 'offer_01'},
                },
              ],
            },
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.addLineItem(
        'cart_01',
        const CustomerAddLineItemReq(offerId: 'offer_01', quantity: 1),
      );
      expect(
        captured?.path,
        equals('/store/carts/cart_01/line-items'),
      );
      expect(
        (captured?.data as Map)['offer_id'],
        equals('offer_01'),
      );
      expect(res.cart.items.first.offerId, equals('offer_01'));
    });

    test('complete posts /store/carts/:id/complete', () async {
      RequestOptions? captured;
      final resource = CustomerCartsResource(
        stubDio(
          payload: {
            'type': 'order_group',
            'order_group': {'id': 'og_01', 'seller_count': 1},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.complete('cart_01');
      expect(
        captured?.path,
        equals('/store/carts/cart_01/complete'),
      );
      expect(res.orderGroup?.id, equals('og_01'));
    });
  });
}
