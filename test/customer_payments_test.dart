import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

import 'resources_test.dart' show stubDio;

void main() {
  group('Payment models', () {
    test('collection with sessions round-trips', () {
      const session = CustomerPaymentSession(
        id: 'ps_01',
        amount: 1500,
        currencyCode: 'eur',
        providerId: 'pp_system_default',
        status: 'pending',
      );
      const collection = CustomerPaymentCollection(
        id: 'pay_01',
        currencyCode: 'eur',
        amount: 1500,
        paymentSessions: [session],
      );
      final back = CustomerPaymentCollection.fromJson(collection.toJson());
      expect(back.paymentSessions.single.providerId, equals('pp_system_default'));

      const res = CustomerPaymentCollectionRes(paymentCollection: collection);
      expect(
        CustomerPaymentCollectionRes.fromJson(res.toJson())
            .paymentCollection
            .id,
        equals('pay_01'),
      );
    });

    test('id-only collection tolerates missing fields', () {
      final collection =
          CustomerPaymentCollection.fromJson(const {'id': 'pay_02'});
      expect(collection.amount, isNull);
      expect(collection.paymentSessions, isEmpty);
    });

    test('session create body serializes', () {
      const body = CustomerCreatePaymentSessionReq(
        providerId: 'pp_system_default',
      );
      expect(body.toJson()['provider_id'], equals('pp_system_default'));
      expect(body.toJson().containsKey('data'), isFalse);
    });
  });

  group('CustomerPaymentsResource', () {
    test('createCollection posts cart_id', () async {
      RequestOptions? captured;
      Map<String, dynamic>? body;
      final resource = CustomerPaymentsResource(
        stubDio(
          payload: {
            'payment_collection': {'id': 'pay_01', 'currency_code': 'eur'},
          },
          onRequest: (options) {
            captured = options;
            body = options.data is Map<String, dynamic>
                ? Map<String, dynamic>.from(options.data as Map)
                : null;
          },
        ),
      );

      final res = await resource.createCollection(
        const CustomerCreatePaymentCollectionReq(cartId: 'cart_01'),
      );
      expect(captured?.path, equals('/store/payment-collections'));
      expect(captured?.method, equals('POST'));
      expect(body?['cart_id'], equals('cart_01'));
      expect(res.paymentCollection.id, equals('pay_01'));
    });

    test('createSession posts provider_id to :id/payment-sessions', () async {
      RequestOptions? captured;
      Map<String, dynamic>? body;
      final resource = CustomerPaymentsResource(
        stubDio(
          payload: {
            'payment_collection': {
              'id': 'pay_01',
              'payment_sessions': [
                {'id': 'ps_01', 'provider_id': 'pp_system_default'},
              ],
            },
          },
          onRequest: (options) {
            captured = options;
            body = options.data is Map<String, dynamic>
                ? Map<String, dynamic>.from(options.data as Map)
                : null;
          },
        ),
      );

      final res = await resource.createSession(
        'pay_01',
        const CustomerCreatePaymentSessionReq(
          providerId: 'pp_system_default',
        ),
      );
      expect(
        captured?.path,
        equals('/store/payment-collections/pay_01/payment-sessions'),
      );
      expect(captured?.method, equals('POST'));
      expect(body?['provider_id'], equals('pp_system_default'));
      expect(
        res.paymentCollection.paymentSessions.single.id,
        equals('ps_01'),
      );
    });
  });
}
