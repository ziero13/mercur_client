import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

/// Sequenced stub: answers each request in order and records all of them.
Dio sequencedDio(
  List<Map<String, dynamic>> payloads,
  List<RequestOptions> captured,
) {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9000'));
  var i = 0;
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        captured.add(options);
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: payloads[i++],
          ),
        );
      },
    ),
  );
  return dio;
}

void main() {
  group('Auth models', () {
    test('LoginReq round-trip', () {
      const req = LoginReq(email: 'a@b.c', password: 'secret');
      final back = LoginReq.fromJson(req.toJson());
      expect(back.email, equals('a@b.c'));
    });

    test('TokenRes round-trip', () {
      const res = TokenRes(token: 'tok_123');
      expect(TokenRes.fromJson(res.toJson()).token, equals('tok_123'));
    });

    test('Customer round-trip', () {
      const customer = Customer(
        id: 'cust_01',
        email: 'a@b.c',
        firstName: 'Awa',
        lastName: 'Diallo',
      );
      final back = Customer.fromJson(customer.toJson());
      expect(back.toJson(), equals(customer.toJson()));
    });
  });

  group('CustomerAuthResource.registerCustomer', () {
    test('3 calls: register, create (Bearer), login', () async {
      final captured = <RequestOptions>[];
      String? sunk;
      final auth = CustomerAuthResource(
        sequencedDio(
          [
            {'token': 'pre_token'},
            {
              'customer': {
                'id': 'cust_01',
                'email': 'new@example.com',
                'first_name': 'Awa',
              },
            },
            {'token': 'final_token'},
          ],
          captured,
        ),
        onCustomerToken: (t) => sunk = t,
      );

      final res = await auth.registerCustomer(
        const RegisterCustomerReq(
          email: 'new@example.com',
          password: 'supersecret',
          firstName: 'Awa',
        ),
      );

      expect(captured.length, equals(3));
      expect(captured[0].path, equals('/auth/customer/emailpass/register'));
      expect(
        (captured[0].data as Map)['password'],
        equals('supersecret'),
      );
      expect(captured[1].path, equals('/store/customers'));
      expect(
        captured[1].headers['Authorization'],
        equals('Bearer pre_token'),
      );
      expect(
        (captured[1].data as Map)['first_name'],
        equals('Awa'),
      );
      expect(captured[2].path, equals('/auth/customer/emailpass'));
      expect(res.customer.id, equals('cust_01'));
      expect(res.token, equals('final_token'));
      expect(sunk, equals('final_token'));
    });
  });

  group('Seller/Admin login', () {
    test('member login hits /auth/member/emailpass + sinks token', () async {
      final captured = <RequestOptions>[];
      String? sunk;
      final auth = SellerAuthResource(
        sequencedDio(
          [
            {'token': 'member_tok'}
          ],
          captured,
        ),
        onMemberToken: (t) => sunk = t,
      );
      final res = await auth.login(
        const LoginReq(email: 'seller@mercur.dev', password: 'supersecret'),
      );
      expect(captured.single.path, equals('/auth/member/emailpass'));
      expect(res.token, equals('member_tok'));
      expect(sunk, equals('member_tok'));
    });

    test('operator login hits /auth/user/emailpass + sinks token', () async {
      final captured = <RequestOptions>[];
      String? sunk;
      final auth = AdminAuthResource(
        sequencedDio(
          [
            {'token': 'user_tok'}
          ],
          captured,
        ),
        onUserToken: (t) => sunk = t,
      );
      final res = await auth.login(
        const LoginReq(email: 'admin@mercur-test.com', password: 'supersecret'),
      );
      expect(captured.single.path, equals('/auth/user/emailpass'));
      expect(res.token, equals('user_tok'));
      expect(sunk, equals('user_tok'));
    });
  });

  group('Mercur facade auth wiring', () {
    test('customer login installs Bearer on later calls', () async {
      final mercur = Mercur(
        const Configuration(
          baseUrl: 'http://localhost:9000',
          publishableKey: 'pk_test',
        ),
      );
      // Stub network at the tail of the customer Dio chain.
      final seen = <RequestOptions>[];
      mercur.customerDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            seen.add(options);
            final isAuth = options.path.startsWith('/auth/');
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: isAuth
                    ? {'token': 'cust_tok'}
                    : {'products': [], 'count': 0, 'offset': 0, 'limit': 0},
              ),
            );
          },
        ),
      );

      await mercur.customer.auth.login(
        const LoginReq(email: 'c@t.com', password: 'secret'),
      );
      await mercur.customer.products.list();
      expect(
        seen.last.headers['Authorization'],
        equals('Bearer cust_tok'),
      );
    });
  });
}
