import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mercur_client/mercur_client.dart';
import 'package:test/test.dart';

Dio stubUploadsDio({
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
  group('SellerUploadsResource', () {
    test('create hits POST /vendor/uploads with multipart files', () async {
      RequestOptions? captured;
      final resource = SellerUploadsResource(
        stubUploadsDio(
          respond: (options) {
            expect(options.method, equals('POST'));
            expect(options.path, equals('/vendor/uploads'));
            expect(options.data, isA<FormData>());
            final form = options.data as FormData;
            expect(form.files.length, equals(2));
            expect(form.files.first.value.filename, equals('photo.jpg'));
            return {
              'files': [
                {'id': 'file_01', 'url': 'https://files.example.com/photo.jpg'},
              ],
            };
          },
          onRequest: (options) => captured = options,
        ),
      );

      final tmp = await Directory.systemTemp.createTemp('uploads_test');
      try {
        final first = File('${tmp.path}/photo.jpg');
        await first.writeAsBytes([0xFF, 0xD8, 0xFF, 0xD9]);
        final second = File('${tmp.path}/second.png');
        await second.writeAsBytes([0x89, 0x50, 0x4E, 0x47]);

        final res = await resource.create(
          filePaths: [first.path, second.path],
        );
        expect(res.files.length, equals(1));
        expect(
          res.files.first.url,
          equals('https://files.example.com/photo.jpg'),
        );
      } finally {
        await tmp.delete(recursive: true);
      }

      expect(captured?.method, equals('POST'));
      expect(captured?.path, equals('/vendor/uploads'));
    });

    test('SellerUploadedFile round-trip fromJson(toJson(x)) == x', () {
      const file = SellerUploadedFile(
        id: 'file_01',
        url: 'https://files.example.com/photo.jpg',
      );
      final back = SellerUploadedFile.fromJson(file.toJson());
      expect(back.id, equals(file.id));
      expect(back.url, equals(file.url));
    });
  });
}
