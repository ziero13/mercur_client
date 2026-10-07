import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

Dio stubMoneyDio({
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
  group('SellerPaymentsResource', () {
    test('list hits GET /vendor/payments', () async {
      RequestOptions? captured;
      final resource = SellerPaymentsResource(
        stubMoneyDio(
          respond: (options) {
            expect(options.method, equals('GET'));
            expect(options.path, equals('/vendor/payments'));
            return {'payments': [], 'count': 0, 'offset': 0, 'limit': 50};
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list(const SellerListMoneyParams());
      expect(captured?.method, equals('GET'));
      expect(res.count, equals(0));
    });

    test('capture POSTs amount', () async {
      RequestOptions? captured;
      final resource = SellerPaymentsResource(
        stubMoneyDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            return {
              'payment': {
                'id': 'pay_01',
                'amount': 9900,
                'currency_code': 'eur',
                'captured_at': '2026-10-07T00:00:00.000Z',
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.capture(
        'pay_01',
        const SellerCapturePaymentReq(amount: 9900),
      );
      expect(captured?.path, equals('/vendor/payments/pay_01/capture'));
      expect(res.payment.capturedAt, isNotNull);
    });

    test('providers hits payment-providers', () async {
      RequestOptions? captured;
      final resource = SellerPaymentsResource(
        stubMoneyDio(
          respond: (_) => {
            'payment_providers': [
              {'id': 'pp_system', 'is_enabled': true},
            ],
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.providers();
      expect(captured?.path,
          equals('/vendor/payments/payment-providers'));
      expect(res.providers.first.id, equals('pp_system'));
    });
  });

  group('SellerPayoutsResource', () {
    test('payouts + accounts parse doc shapes', () async {
      final resource = SellerPayoutsResource(
        stubMoneyDio(
          respond: (options) {
            if (options.path == '/vendor/payouts') {
              return {
                'payouts': [
                  {
                    'id': 'po_01',
                    'display_id': 7,
                    'amount': 50000,
                    'currency_code': 'eur',
                    'status': 'paid',
                  },
                ],
                'count': 1,
                'offset': 0,
                'limit': 50,
              };
            }
            return {
              'payout_accounts': [
                {'id': 'pa_01', 'status': 'active'},
              ],
              'count': 1,
              'offset': 0,
              'limit': 50,
            };
          },
          onRequest: (_) {},
        ),
      );

      final payouts = await resource.list();
      expect(payouts.payouts.first.status, equals('paid'));
      final accounts = await resource.accounts();
      expect(accounts.accounts.first.status, equals('active'));
    });

    test('onboard POSTs and returns onboarding', () async {
      RequestOptions? captured;
      final resource = SellerPayoutsResource(
        stubMoneyDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            return {
              'onboarding': {'id': 'ob_01'},
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.onboard('pa_01');
      expect(captured?.path,
          equals('/vendor/payout-accounts/pa_01/onboarding'));
      expect(res.onboarding.id, equals('ob_01'));
    });
  });
}
