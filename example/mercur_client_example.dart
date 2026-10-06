import 'package:mercur_client/mercur_client.dart';

void main() {
  final mercur = Mercur(
    const Configuration(
      baseUrl: 'http://localhost:9000',
      publishableKey: 'pk_replace_me',
    ),
  );
  print('customer ready: ${mercur.customerDio.options.baseUrl}');
}
