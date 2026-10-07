import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

import 'resources_test.dart' show stubDio;

void main() {
  group('Order models', () {
    test('order round-trips', () {
      const order = CustomerOrder(
        id: 'ord_01',
        status: 'pending',
        email: 'a@b.co',
        total: 5400,
        items: [CustomerOrderLineItem(id: 'li_01', quantity: 2)],
      );
      final back = CustomerOrder.fromJson(order.toJson());
      expect(back.status, equals('pending'));
      expect(back.items.single.quantity, equals(2));
    });

    test('create-return body nests return_shipping', () {
      const req = CustomerCreateReturnReq(
        orderId: 'ord_01',
        items: [CustomerReturnItemReq(id: 'li_01', quantity: 1)],
        optionId: 'so_01',
      );
      final json = req.toJson();
      expect(
        (json['return_shipping'] as Map)['option_id'],
        equals('so_01'),
      );
      expect(
        CustomerCreateReturnReq.fromJson(json).optionId,
        equals('so_01'),
      );
    });
  });

  group('CustomerOrdersResource', () {
    test('list hits /store/orders', () async {
      RequestOptions? captured;
      final resource = CustomerOrdersResource(
        stubDio(
          payload: {
            'orders': [
              {'id': 'ord_01', 'status': 'pending'},
            ],
            'count': 1,
            'offset': 0,
            'limit': 10,
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.list(
        const CustomerListOrdersParams(limit: 10),
      );
      expect(captured?.path, equals('/store/orders'));
      expect(res.count, equals(1));
      expect(res.orders.single.id, equals('ord_01'));
    });

    test('retrieve + transfer flow hit order sub-routes', () async {
      final paths = <String>[];
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            paths.add('${options.method} ${options.path}');
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'order': {'id': 'ord_01'},
                },
              ),
            );
          },
        ),
      );
      final resource = CustomerOrdersResource(dio);

      await resource.retrieve('ord_01');
      await resource.requestTransfer('ord_01');
      await resource.cancelTransfer('ord_01');
      await resource.acceptTransfer(
        'ord_01',
        const CustomerAcceptOrderTransferReq(token: 'tok_01'),
      );
      await resource.declineTransfer(
        'ord_01',
        const CustomerDeclineOrderTransferReq(token: 'tok_01'),
      );

      expect(
        paths,
        equals([
          'GET /store/orders/ord_01',
          'POST /store/orders/ord_01/transfer/request',
          'POST /store/orders/ord_01/transfer/cancel',
          'POST /store/orders/ord_01/transfer/accept',
          'POST /store/orders/ord_01/transfer/decline',
        ]),
      );
    });
  });

  group('CustomerReturnsResource', () {
    test('create posts /store/returns', () async {
      RequestOptions? captured;
      final resource = CustomerReturnsResource(
        stubDio(
          payload: {
            'return': {'id': 'ret_01', 'order_id': 'ord_01'},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.create(
        const CustomerCreateReturnReq(
          orderId: 'ord_01',
          items: [CustomerReturnItemReq(id: 'li_01', quantity: 1)],
        ),
      );
      expect(captured?.path, equals('/store/returns'));
      expect(res.returnRecord.orderId, equals('ord_01'));
    });

    test('reasons list hits /store/return-reasons (empty 200)', () async {
      RequestOptions? captured;
      final resource = CustomerReturnsResource(
        stubDio(
          payload: {
            'return_reasons': [],
            'count': 0,
            'offset': 0,
            'limit': 10,
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.listReasons();
      expect(captured?.path, equals('/store/return-reasons'));
      expect(res.count, equals(0));
    });
  });
}
