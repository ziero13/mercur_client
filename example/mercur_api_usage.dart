import 'package:mercur_client/mercur_client.dart';

/// Exemple d'usage du client (tranche 1 : lecture Store).
///
/// Tout est typé : pas de `Map` côté appelant — chaque query et réponse
/// est une classe avec `toJson`/`fromJson`.
///
/// Prérequis : backend local (`http://localhost:9000`) + clé publishable :
/// `PUBLISHABLE_KEY=pk_... dart run example/mercur_api_usage.dart`
Future<void> main() async {
  const publishableKey = String.fromEnvironment(
    'PUBLISHABLE_KEY',
    defaultValue: 'pk_replace_me',
  );

  final mercur = Mercur(
    const Configuration(
      baseUrl: 'http://localhost:9000',
      publishableKey: publishableKey,
    ),
  );

  // CUSTOMER — parcours acheteur anonyme (lecture seule, tranche 1).
  final products = await mercur.customer.products.list(
    const CustomerListProductsParams(
      limit: 10,
      fields: ['id', 'title', 'handle', 'thumbnail'],
    ),
  );
  print(
    '${products.count} produits, premier : '
    '${products.products.isEmpty ? 'aucun' : products.products.first.title}',
  );

  final sellers = await mercur.customer.sellers.list(
    const CustomerListSellersParams(limit: 10),
  );
  print(
    '${sellers.count} vendeurs, premier : '
    '${sellers.sellers.isEmpty ? 'aucun' : sellers.sellers.first.name}',
  );

  const regionId = String.fromEnvironment('REGION_ID', defaultValue: '');
  final offers = await mercur.customer.offers.list(
    CustomerListOffersParams(
      limit: 5,
      fields: const ['+calculated_price'],
      regionId: regionId.isEmpty ? null : regionId,
    ),
  );
  print('${offers.count} offres.');
  for (final o in offers.offers) {
    final calc = o.calculatedPrice;
    final price = calc != null
        ? '${calc.calculatedAmount} ${calc.currencyCode}'
        : o.prices.isEmpty
            ? 'n/a'
            : '${o.prices.first.amount} ${o.prices.first.currencyCode}';
    print('- ${o.sku} : $price');
  }

  // SELLER / ADMIN — tranches suivantes (coquilles en place).
}
