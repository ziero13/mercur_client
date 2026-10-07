import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

import 'resources_test.dart' show stubDio;

void main() {
  group('Misc models', () {
    test('currency keyed by code round-trips', () {
      const cur = CustomerCurrency(code: 'eur', name: 'Euro', symbol: '€');
      final back = CustomerCurrency.fromJson(cur.toJson());
      expect(back.symbol, equals('€'));

      const res = CustomerCurrenciesRes(
        currencies: [cur],
        count: 1,
      );
      expect(
        CustomerCurrenciesRes.fromJson(res.toJson()).currencies.single.code,
        equals('eur'),
      );
    });

    test('providers params require region_id', () {
      const q = CustomerListPaymentProvidersParams(regionId: 'reg_01');
      expect(q.toQuery()['region_id'], equals('reg_01'));
    });
  });

  group('CustomerMiscResource', () {
    test('listCurrencies hits /store/currencies', () async {
      RequestOptions? captured;
      final resource = CustomerMiscResource(
        stubDio(
          payload: {
            'currencies': [
              {'code': 'eur', 'name': 'Euro'},
            ],
            'count': 1,
            'offset': 0,
            'limit': 10,
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.listCurrencies(
        const CustomerListCurrenciesParams(limit: 10),
      );
      expect(captured?.path, equals('/store/currencies'));
      expect(res.currencies.single.code, equals('eur'));
    });

    test('retrieveCurrency gets /store/currencies/:code', () async {
      RequestOptions? captured;
      final resource = CustomerMiscResource(
        stubDio(
          payload: {
            'currency': {'code': 'eur', 'symbol': '€'},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.retrieveCurrency('eur');
      expect(captured?.path, equals('/store/currencies/eur'));
      expect(res.currency.symbol, equals('€'));
    });

    test('locales + providers hit their paths', () async {
      final paths = <String>[];
      final queries = <Map<String, dynamic>>[];
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            paths.add(options.path);
            queries.add(Map<String, dynamic>.from(options.queryParameters));
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: options.path == '/store/locales'
                    ? {
                        'locales': [
                          {'code': 'fr', 'name': 'Français'},
                        ],
                      }
                    : {
                        'payment_providers': [
                          {'id': 'pp_system_default', 'is_enabled': true},
                        ],
                        'count': 1,
                        'offset': 0,
                        'limit': 20,
                      },
              ),
            );
          },
        ),
      );
      final resource = CustomerMiscResource(dio);

      final locales = await resource.listLocales();
      expect(locales.locales.single.code, equals('fr'));
      final providers = await resource.listPaymentProviders(
        const CustomerListPaymentProvidersParams(regionId: 'reg_01'),
      );
      expect(providers.paymentProviders.single.id, equals('pp_system_default'));

      expect(paths, equals(['/store/locales', '/store/payment-providers']));
      expect(queries[1]['region_id'], equals('reg_01'));
    });
  });
}
