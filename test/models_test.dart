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

    test('SellerCreateProductReq with categories/tags', () {
      const req = SellerCreateProductReq(
        title: 'Sac',
        typeId: 'ty1',
        collectionId: 'c1',
        categoryIds: ['pcat_01'],
        tagIds: ['t1'],
      );
      final json = req.toJson();
      expect(json['type_id'], equals('ty1'));
      expect(json['categories'], equals([
        {'id': 'pcat_01'},
      ]));
      expect(json['tags'], equals([
        {'id': 't1'},
      ]));
    });

    test('SellerUpdateProductReq with images/org/dims', () {
      const req = SellerUpdateProductReq(
        title: 'Sac',
        images: [
          SellerProductImage(id: 'img_01', url: 'https://cdn.test/a.png'),
        ],
        typeId: 'ty1',
        categoryIds: ['pcat_01'],
        weight: 1.5,
        material: 'Raphia',
      );
      final json = req.toJson();
      expect(json['images'], equals([
        {'id': 'img_01', 'url': 'https://cdn.test/a.png'},
      ]));
      expect(json['categories'], equals([
        {'id': 'pcat_01'},
      ]));
      expect(json['weight'], equals(1.5));
    });

    test('SellerVariantReq with options', () {
      const req = SellerVariantReq(
        title: 'Rouge / M',
        options: {'Couleur': 'Rouge', 'Taille': 'M'},
        variantRank: 0,
      );
      final json = req.toJson();
      expect(json['options'], equals({'Couleur': 'Rouge', 'Taille': 'M'}));
    });

    test('SellerProduct parses org + computed attributes', () {
      final product = SellerProduct.fromJson({
        'id': 'prod_01',
        'title': 'Sac',
        'handle': 'sac',
        'status': 'draft',
        'weight': 1.5,
        'material': 'Raphia',
        'categories': [
          {'id': 'pcat_01', 'name': 'Sacs'},
        ],
        'collection': {'id': 'c1', 'title': 'Été'},
        'attributes': [
          {
            'id': 'a1',
            'name': 'Taille',
            'type': 'multi_select',
            'is_variant_axis': true,
            'is_required': true,
            'is_scoped': true,
            'values': [
              {'id': 'v1', 'name': 'M'},
            ],
            'all_values': [
              {'id': 'v1', 'name': 'M'},
              {'id': 'v2', 'name': 'L'},
            ],
          },
        ],
      });
      expect(product.weight, equals(1.5));
      expect(product.categories.single.id, equals('pcat_01'));
      expect(product.collectionId, equals('c1'));
      final attr = product.attributes.single;
      expect(attr.isVariantAxis, isTrue);
      expect(attr.values.single.name, equals('M'));
      expect(attr.allValues, hasLength(2));
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
