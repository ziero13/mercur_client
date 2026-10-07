import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

Dio stubPricingDio({
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
  group('SellerPricingResource price lists', () {
    test('create → retrieve → delete cycle', () async {
      final seen = <String>[];
      final resource = SellerPricingResource(
        stubPricingDio(
          respond: (options) {
            seen.add('${options.method} ${options.path}');
            if (options.method == 'DELETE') {
              return {
                'id': 'pl_01',
                'object': 'price_list',
                'deleted': true,
              };
            }
            return {
              'price_list': {
                'id': 'pl_01',
                'title': 'Summer Sale',
                'description': 'Summer discounts',
                'status': 'draft',
              },
            };
          },
          onRequest: (_) {},
        ),
      );

      final created = await resource.createPriceList(
        const SellerCreatePriceListReq(
          title: 'Summer Sale',
          description: 'Summer discounts',
        ),
      );
      expect(created.list.title, equals('Summer Sale'));
      final retrieved = await resource.retrievePriceList('pl_01');
      expect(retrieved.list.status, equals('draft'));
      final deleted = await resource.deletePriceList('pl_01');
      expect(deleted.deleted, isTrue);
      expect(
        seen,
        equals([
          'POST /vendor/price-lists',
          'GET /vendor/price-lists/pl_01',
          'DELETE /vendor/price-lists/pl_01',
        ]),
      );
    });

    test('batch prices parses created/updated/deleted', () async {
      final resource = SellerPricingResource(
        stubPricingDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path,
                equals('/vendor/price-lists/pl_01/prices/batch'));
            return {
              'created': [
                {'currency_code': 'eur', 'amount': 8000},
              ],
              'updated': [],
              'deleted': {
                'id': ['pr_09'],
                'object': 'price',
                'deleted': true,
              },
            };
          },
          onRequest: (_) {},
        ),
      );

      final res = await resource.batchPrices(
        'pl_01',
        SellerPriceBatchReq(
          create: const [
            SellerPriceListPriceReq(
              currencyCode: 'eur',
              amount: 8000,
              variantId: 'var_01',
            ),
          ],
          delete: const ['pr_09'],
        ),
      );
      expect(res.created.first.amount, equals(8000));
      expect(res.deletedIds, equals(['pr_09']));
    });
  });

  group('SellerPricingResource campaigns', () {
    test('create → update → promotions → delete chain', () async {
      final seen = <String>[];
      final resource = SellerPricingResource(
        stubPricingDio(
          respond: (options) {
            seen.add('${options.method} ${options.path}');
            if (options.method == 'DELETE') {
              return {'id': 'camp_01', 'object': 'campaign', 'deleted': true};
            }
            return {
              'campaign': {
                'id': 'camp_01',
                'name': 'Back to School',
                'campaign_identifier': 'bts-2026',
              },
            };
          },
          onRequest: (_) {},
        ),
      );

      final created = await resource.createCampaign(
        const SellerCreateCampaignReq(
          name: 'Back to School',
          campaignIdentifier: 'bts-2026',
        ),
      );
      expect(created.campaign.campaignIdentifier, equals('bts-2026'));
      await resource.updatePromotions(
        'camp_01',
        const SellerCampaignPromotionsReq(add: ['promo_01']),
      );
      final deleted = await resource.deleteCampaign('camp_01');
      expect(deleted.object, equals('campaign'));
      expect(deleted.deleted, isTrue);
      expect(
        seen,
        equals([
          'POST /vendor/campaigns',
          'POST /vendor/campaigns/camp_01/promotions',
          'DELETE /vendor/campaigns/camp_01',
        ]),
      );
    });

    test('lists parse empty seed', () async {
      final resource = SellerPricingResource(
        stubPricingDio(
          respond: (options) => options.path.endsWith('price-lists')
              ? {
                  'price_lists': [],
                  'count': 0,
                  'offset': 0,
                  'limit': 50,
                }
              : {
                  'campaigns': [],
                  'count': 0,
                  'offset': 0,
                  'limit': 50,
                },
          onRequest: (_) {},
        ),
      );

      expect((await resource.listPriceLists()).count, equals(0));
      expect((await resource.listCampaigns()).count, equals(0));
    });
  });
}
