import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

void main() {
  group('Round-trips fromJson(toJson(x)) == x (wire shape)', () {
    test('CustomerProduct', () {
      const product = CustomerProduct(
        id: 'prod_01',
        title: 'Linen Shirt',
        handle: 'linen-shirt',
        status: 'published',
        thumbnail: 'https://cdn.test/shirt.jpg',
        variants: [
          CustomerProductVariant(id: 'var_01', title: 'S', sku: 'SHIRT-S'),
        ],
      );
      final back = CustomerProduct.fromJson(product.toJson());
      expect(back.toJson(), equals(product.toJson()));
      expect(back.variants.first.sku, equals('SHIRT-S'));
    });

    test('Seller', () {
      const seller = Seller(
        id: 'sel_01',
        name: 'Kickz',
        handle: 'kickz',
        isPremium: true,
      );
      final back = Seller.fromJson(seller.toJson());
      expect(back.toJson(), equals(seller.toJson()));
    });

    test('CustomerListProductsParams serialises lists as CSV', () {
      const params = CustomerListProductsParams(
        limit: 10,
        fields: ['id', '+variants.sku'],
        id: ['prod_01', 'prod_02'],
        isGiftcard: false,
      );
      final q = params.toQuery();
      expect(q['limit'], equals(10));
      expect(q['fields'], equals('id,+variants.sku'));
      expect(q['id'], equals('prod_01,prod_02'));
      expect(q['is_giftcard'], isFalse);
      final back = CustomerListProductsParams.fromJson(params.toJson());
      expect(back.toQuery(), equals(q));
    });

    test('CustomerProductListRes envelope', () {
      const res = CustomerProductListRes(
        products: [
          CustomerProduct(
            id: 'prod_01',
            title: 'A',
            handle: 'a',
            status: 'published',
          ),
        ],
        count: 1,
        offset: 0,
        limit: 50,
      );
      final back = CustomerProductListRes.fromJson(res.toJson());
      expect(back.count, equals(1));
      expect(back.products.first.id, equals('prod_01'));
    });

    test('SellerStatus wire mapping', () {
      expect(
        SellerStatus.fromWire('pending_approval'),
        equals(SellerStatus.pendingApproval),
      );
      expect(SellerStatus.open.toWire(), equals('open'));
    });

    test('ApiError from envelope', () {
      final err = ApiError.fromJson(
        const {'type': 'not_found', 'message': 'Nope'},
        statusCode: 404,
      );
      expect(err.type, equals(ApiErrorType.notFound));
      expect(err.statusCode, equals(404));
    });

    test('StoreHeaders inject publishable key + bearer', () {
      const headers = StoreHeaders(
        publishableKey: 'pk_test',
        customerToken: 'tok',
      );
      expect(headers.toHeaders(), equals({
        'x-publishable-api-key': 'pk_test',
        'Authorization': 'Bearer tok',
      }));
    });
  });
}
