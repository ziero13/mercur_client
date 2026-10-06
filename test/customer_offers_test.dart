import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

import 'resources_test.dart' show stubDio;

void main() {
  group('Offer models', () {
    test('round-trip with prices + calculated price', () {
      const offer = Offer(
        id: 'offer_01',
        sellerId: 'sel_01',
        variantId: 'var_01',
        productId: 'prod_01',
        sku: 'KICKZ-M',
        seller: OfferSellerRef(id: 'sel_01', name: 'Kickz', handle: 'kickz'),
        productVariant: OfferVariantRef(id: 'var_01', title: 'M'),
        prices: [
          OfferPrice(amount: 4500, currencyCode: 'eur', minQuantity: 1),
        ],
        calculatedPrice: CalculatedPrice(
          calculatedAmount: 4500,
          calculatedAmountWithTax: 5400,
          currencyCode: 'eur',
        ),
        inStock: true,
      );
      final back = Offer.fromJson(offer.toJson());
      expect(back.toJson(), equals(offer.toJson()));
      expect(back.calculatedPrice?.calculatedAmountWithTax, equals(5400));
    });

    test('partial fields: only id required', () {
      final back = Offer.fromJson(const {'id': 'offer_01'});
      expect(back.id, equals('offer_01'));
      expect(back.sku, isNull);
      expect(back.prices, isEmpty);
    });

    test('CustomerListOffersParams serialises filters', () {
      const params = CustomerListOffersParams(
        limit: 5,
        productId: ['prod_01'],
        fields: ['+calculated_price'],
        regionId: 'reg_01',
      );
      final q = params.toQuery();
      expect(q['product_id'], equals('prod_01'));
      expect(q['fields'], equals('+calculated_price'));
      expect(q['region_id'], equals('reg_01'));
      final back = CustomerListOffersParams.fromJson(params.toJson());
      expect(back.toQuery(), equals(q));
    });
  });

  group('CustomerOffersResource', () {
    test('list hits /store/offers', () async {
      RequestOptions? captured;
      final resource = CustomerOffersResource(
        stubDio(
          payload: {
            'offers': [
              {
                'id': 'offer_01',
                'seller_id': 'sel_01',
                'variant_id': 'var_01',
                'product_id': 'prod_01',
                'sku': 'KICKZ-M',
                'prices': [
                  {'amount': 4500, 'currency_code': 'eur'},
                ],
              },
            ],
            'count': 1,
            'offset': 0,
            'limit': 5,
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list(
        const CustomerListOffersParams(limit: 5),
      );
      expect(captured?.path, equals('/store/offers'));
      expect(captured?.queryParameters['limit'], equals(5));
      expect(res.offers.first.sku, equals('KICKZ-M'));
    });

    test('retrieve hits /store/offers/:id', () async {
      RequestOptions? captured;
      final resource = CustomerOffersResource(
        stubDio(
          payload: {
            'offer': {'id': 'offer_01', 'sku': 'KICKZ-M'},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.retrieve('offer_01');
      expect(captured?.path, equals('/store/offers/offer_01'));
      expect(res.offer.id, equals('offer_01'));
    });
  });
}
