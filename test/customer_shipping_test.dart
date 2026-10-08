import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

import 'resources_test.dart' show stubDio;

void main() {
  group('Shipping option models', () {
    test('round-trips grouped map envelope', () {
      const res = CustomerShippingOptionsRes(
        optionsBySeller: {
          'sel_01': [
            CustomerShippingOption(
              id: 'so_01',
              name: 'Standard',
              providerId: 'manual_manual',
              amount: 900,
              typeCode: 'standard',
              typeLabel: 'Standard',
            ),
          ],
        },
      );
      final back = CustomerShippingOptionsRes.fromJson(res.toJson());
      expect(back.optionsBySeller.keys, equals(['sel_01']));
      expect(back.options.single.amount, equals(900));
      expect(back.options.single.typeCode, equals('standard'));
    });

    test('empty map parses (empty cart)', () {
      final res = CustomerShippingOptionsRes.fromJson(
        const {'shipping_options': {}},
      );
      expect(res.optionsBySeller, isEmpty);
      expect(res.options, isEmpty);
    });

    test('region round-trips with countries', () {
      const region = CustomerRegion(
        id: 'reg_01',
        name: 'Europe',
        currencyCode: 'eur',
        countries: [CustomerCountry(iso2: 'fr', displayName: 'France')],
      );
      final back = CustomerRegion.fromJson(region.toJson());
      expect(back.currencyCode, equals('eur'));
      expect(back.countries.single.iso2, equals('fr'));
    });

    test('country round-trips full wire shape', () {
      const country = CustomerCountry(
        iso2: 'fr',
        iso3: 'fra',
        numCode: '250',
        name: 'FRANCE',
        displayName: 'France',
        regionId: 'reg_01',
      );
      final back = CustomerCountry.fromJson(
        country.toJson(),
      );
      expect(back.iso3, equals('fra'));
      expect(back.numCode, equals('250'));
      expect(back.name, equals('FRANCE'));
      expect(back.displayName, equals('France'));
      expect(back.regionId, equals('reg_01'));
    });
  });

  group('CustomerShippingOptionsResource', () {
    test('list hits /store/shipping-options with cart_id', () async {
      RequestOptions? captured;
      final resource = CustomerShippingOptionsResource(
        stubDio(
          payload: {
            'shipping_options': {
              'sel_01': [
                {'id': 'so_01', 'name': 'Standard', 'amount': 900},
              ],
            },
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list(
        const CustomerListShippingOptionsParams(cartId: 'cart_01'),
      );
      expect(captured?.path, equals('/store/shipping-options'));
      expect(captured?.method, equals('GET'));
      expect(
        captured?.queryParameters['cart_id'],
        equals('cart_01'),
      );
      expect(res.optionsBySeller['sel_01']?.single.id, equals('so_01'));
    });

    test('calculate posts cart_id to …/:id/calculate', () async {
      RequestOptions? captured;
      final resource = CustomerShippingOptionsResource(
        stubDio(
          payload: {
            'shipping_option': {'id': 'so_01', 'amount': 900},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.calculate(
        'so_01',
        const CustomerCalculateShippingOptionReq(cartId: 'cart_01'),
      );
      expect(
        captured?.path,
        equals('/store/shipping-options/so_01/calculate'),
      );
      expect(
        (captured?.data as Map)['cart_id'],
        equals('cart_01'),
      );
      expect(res.shippingOption.amount, equals(900));
    });
  });

  group('CustomerRegionsResource', () {
    test('list hits /store/regions with envelope', () async {
      RequestOptions? captured;
      final resource = CustomerRegionsResource(
        stubDio(
          payload: {
            'regions': [
              {'id': 'reg_01', 'name': 'Europe', 'currency_code': 'eur'},
            ],
            'count': 1,
            'offset': 0,
            'limit': 10,
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list(
        const CustomerListRegionsParams(limit: 10),
      );
      expect(captured?.path, equals('/store/regions'));
      expect(res.count, equals(1));
      expect(res.regions.single.name, equals('Europe'));
    });

    test('retrieve gets /store/regions/:id', () async {
      RequestOptions? captured;
      final resource = CustomerRegionsResource(
        stubDio(
          payload: {
            'region': {'id': 'reg_01', 'currency_code': 'eur'},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.retrieve('reg_01');
      expect(captured?.path, equals('/store/regions/reg_01'));
      expect(res.region.currencyCode, equals('eur'));
    });
  });
}
