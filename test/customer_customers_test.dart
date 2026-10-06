import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

import 'resources_test.dart' show stubDio;

void main() {
  group('Customer address models', () {
    test('round-trip', () {
      const address = CustomerAddress(
        id: 'addr_01',
        firstName: 'Awa',
        lastName: 'Diallo',
        address1: '12 rue des Fleurs',
        city: 'Bujumbura',
        countryCode: 'bi',
        isDefaultShipping: true,
      );
      final back = CustomerAddress.fromJson(address.toJson());
      expect(back.toJson(), equals(address.toJson()));
    });

    test('CustomerUpdateReq serialises snake_case', () {
      const req = CustomerUpdateReq(firstName: 'Awa', phone: '+257000000');
      expect(req.toJson(), equals({
        'first_name': 'Awa',
        'phone': '+257000000',
      }));
      final back = CustomerUpdateReq.fromJson(req.toJson());
      expect(back.firstName, equals('Awa'));
    });

    test('CustomerAddressReq round-trip', () {
      const req = CustomerAddressReq(
        city: 'Bujumbura',
        countryCode: 'bi',
        address1: '12 rue des Fleurs',
      );
      final back = CustomerAddressReq.fromJson(req.toJson());
      expect(back.toJson(), equals(req.toJson()));
    });
  });

  group('CustomerCustomersResource', () {
    test('me hits /store/customers/me', () async {
      RequestOptions? captured;
      final resource = CustomerCustomersResource(
        stubDio(
          payload: {
            'customer': {'id': 'cus_01', 'email': 'a@b.c'},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.me();
      expect(captured?.path, equals('/store/customers/me'));
      expect(res.customer.email, equals('a@b.c'));
    });

    test('updateMe posts snake_case body', () async {
      RequestOptions? captured;
      final resource = CustomerCustomersResource(
        stubDio(
          payload: {
            'customer': {'id': 'cus_01', 'first_name': 'Awa'},
          },
          onRequest: (options) => captured = options,
        ),
      );

      final res = await resource.updateMe(
        const CustomerUpdateReq(firstName: 'Awa'),
      );
      expect(captured?.path, equals('/store/customers/me'));
      expect(captured?.method, equals('POST'));
      expect(
        (captured?.data as Map)['first_name'],
        equals('Awa'),
      );
      expect(res.customer.firstName, equals('Awa'));
    });

    test('address CRUD paths', () async {
      final seen = <String>[];
      RequestOptions? last;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            seen.add('${options.method} ${options.path}');
            last = options;
            final isList = options.method == 'GET' &&
                options.path.endsWith('/addresses');
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                // Live shapes: mutations return {customer}, delete
                // returns {id (customer), deleted, ...}.
                data: options.method == 'DELETE'
                    ? {'id': 'cus_01', 'deleted': true}
                    : isList
                        ? {
                            'addresses': [
                                              {'id': 'addr_01', 'city': 'Bujumbura'},
                                            ],
                            'count': 1,
                            'offset': 0,
                            'limit': 50,
                          }
                        : options.method == 'GET'
                            ? {
                                'address': {
                                  'id': 'addr_01',
                                  'city': 'Bujumbura',
                                },
                              }
                            : {
                                'customer': {
                                  'id': 'cus_01',
                                  'addresses': [
                                    {
                                      'id': 'addr_01',
                                      'city': 'Bujumbura',
                                    },
                                  ],
                                },
                              },
              ),
            );
          },
        ),
      );
      final resource = CustomerCustomersResource(dio);

      final list = await resource.listAddresses();
      expect(list.addresses.first.city, equals('Bujumbura'));

      final created = await resource.createAddress(
        const CustomerAddressReq(city: 'Bujumbura', countryCode: 'bi'),
      );
      expect(created.customer.addresses.first.city, equals('Bujumbura'));
      expect((last?.data as Map)['country_code'], equals('bi'));

      final retrieved = await resource.retrieveAddress('addr_01');
      expect(retrieved.address.city, equals('Bujumbura'));

      final updated = await resource.updateAddress(
        'addr_01',
        const CustomerAddressReq(city: 'Gitega'),
      );
      expect(updated.customer.id, equals('cus_01'));

      final deleted = await resource.deleteAddress('addr_01');
      expect(deleted.deleted, isTrue);
      expect(deleted.id, equals('addr_01'));

      expect(seen, equals([
        'GET /store/customers/me/addresses',
        'POST /store/customers/me/addresses',
        'GET /store/customers/me/addresses/addr_01',
        'POST /store/customers/me/addresses/addr_01',
        'DELETE /store/customers/me/addresses/addr_01',
      ]));
    });
  });
}
