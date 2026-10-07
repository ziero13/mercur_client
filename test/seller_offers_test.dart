import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

Dio stubOffersDio({
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
  group('SellerOffersResource', () {
    test('list hits GET /vendor/offers', () async {
      RequestOptions? captured;
      final resource = SellerOffersResource(
        stubOffersDio(
          respond: (options) {
            expect(options.method, equals('GET'));
            expect(options.path, equals('/vendor/offers'));
            return {
              'offers': [
                {
                  'id': 'offer_01',
                  'seller_id': 'sel_01',
                  'variant_id': 'var_01',
                  'sku': 'RUN-42',
                  'manage_inventory': true,
                  'prices': [
                    {'amount': 9900, 'currency_code': 'eur'},
                  ],
                },
              ],
              'count': 1,
              'offset': 0,
              'limit': 50,
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list(const SellerListOffersParams());
      expect(captured?.method, equals('GET'));
      expect(res.offers.first.sku, equals('RUN-42'));
      expect(res.offers.first.prices.first.amount, equals(9900));
    });

    test('create POSTs /vendor/offers and delete confirms', () async {
      RequestOptions? captured;
      var deleted = false;
      final resource = SellerOffersResource(
        stubOffersDio(
          respond: (options) {
            if (options.method == 'POST') {
              return {
                'offer': {
                  'id': 'offer_02',
                  'seller_id': 'sel_01',
                  'variant_id': 'var_01',
                  'sku': 'TMP-01',
                  'prices': [
                    {'amount': 100, 'currency_code': 'eur'},
                  ],
                },
              };
            }
            deleted = true;
            return {'id': 'offer_02', 'object': 'offer', 'deleted': true};
          },
          onRequest: (options) => captured = options,
        ),
      );

      final created = await resource.create(
        SellerCreateOfferReq(
          sku: 'TMP-01',
          variantId: 'var_01',
          shippingProfileId: 'sp_01',
          inventoryItems: const [
            SellerOfferInventoryReq(sku: 'TMP-01'),
          ],
          prices: const [
            SellerOfferPriceReq(amount: 100, currencyCode: 'eur'),
          ],
        ),
      );
      expect(captured?.method, equals('POST'));
      expect(captured?.path, equals('/vendor/offers'));
      expect(created.offer.id, equals('offer_02'));

      final del = await resource.delete('offer_02');
      expect(deleted, isTrue);
      expect(del.deleted, isTrue);
    });

    test('update POSTs /vendor/offers/:id', () async {
      RequestOptions? captured;
      final resource = SellerOffersResource(
        stubOffersDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path, equals('/vendor/offers/offer_01'));
            return {
              'offer': {
                'id': 'offer_01',
                'sku': 'RUN-42',
                'allow_backorder': true,
              },
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.update(
        'offer_01',
        const SellerUpdateOfferReq(allowBackorder: true),
      );
      expect(captured?.path, equals('/vendor/offers/offer_01'));
      expect(res.offer.allowBackorder, isTrue);
    });
  });
}
