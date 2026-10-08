# mercur_client

Typed Dart client for the [Mercur](https://github.com/mercurjs/mercur) marketplace API
(MedusaJS v2 backend). Three entry points mirroring the three HTTP surfaces —
`/store/*`, `/vendor/*`, `/admin/*` — with **zero `Map` in the public API**:
every query, body, response and header set is a typed class with hand-written
`toJson`/`fromJson` (no codegen, no `build_runner`).

## Requirements

- Dart SDK `^3.13.5`
- A running Mercur backend (local dev: `http://localhost:9000`)
- A publishable API key (`pk_...`) for the Store surface

## Install

```yaml
dependencies:
  mercur_client:
    git:
      url: https://github.com/<org>/mercur_client.git
      ref: main
```

Single runtime dependency: `dio ^5.11.1`. Dev: `test`, `lints`.

## Usage

```dart
import 'package:mercur_client/mercur_client.dart';

final mercur = Mercur(
  const Configuration(
    baseUrl: 'http://localhost:9000',
    publishableKey: 'pk_...',
  ),
);
```

### Customer — `/store/*` (buyer)

Publishable key is sent automatically as `x-publishable-api-key` on every call.

```dart
// Anonymous reads
final products = await mercur.customer.products.list(
  const CustomerListProductsParams(limit: 10),
);
print('${products.count} products');

// Login (installs the Bearer on the customer Dio automatically)
await mercur.customer.auth.login(
  const LoginReq(email: 'jane@example.com', password: 'secret'),
);

// Registration is one call client-side (3 HTTP steps server-side:
// register → POST /store/customers → login). Requires a clean session:
// fresh client or `mercur.clearAuth()` first — the register endpoint
// rejects already-authenticated callers (400).
await mercur.customer.auth.registerCustomer(
  const RegisterCustomerReq(email: 'new@example.com', password: 'secret'),
);

// Checkout (offer_id, never variant_id — backend contract)
final cart = await mercur.customer.carts.create(
  const CustomerCreateCartReq(regionId: '<region_id>'),
);
await mercur.customer.carts.addLineItem(
  cart.cart.id,
  const CustomerAddLineItemReq(offerId: '<offer_id>', quantity: 1),
);
final collection = await mercur.customer.payments.createCollection(
  const CustomerCreatePaymentCollectionReq(cartId: '<cart_id>'), // idempotent
);
await mercur.customer.payments.createSession(
  collection.paymentCollection.id,
  const CustomerCreatePaymentSessionReq(providerId: 'pp_system_default'),
);
final completed = await mercur.customer.carts.complete(cart.cart.id);
```

Note: `list` on order groups sends restricted `fields` by default —
a bare call 400s server-side on the relation-expansion cap.

### Seller — `/vendor/*` (vendor)

Member Bearer + seller scoping via `x-seller-id` header (or a prior `select`).

```dart
await mercur.seller.auth.login(
  const LoginReq(email: 'seller@mercur.dev', password: 'supersecret'),
);
// Unscoped GET /vendor/sellers returns memberships (pick one)…
final memberships = await mercur.seller.sellers.list();
// …then scope (installs x-seller-id automatically):
final sellerId = memberships.sellerMembers.first.sellerId!;
await mercur.seller.sellers.select(SellerSelectReq(sellerId: sellerId));
// …or set it directly:
mercur.setSellerId('<seller_id>');

final offers = await mercur.seller.offers.list(
  const SellerListOffersParams(limit: 10),
);
```

### Admin — `/admin/*` (operator)

```dart
await mercur.admin.auth.login(
  const LoginReq(email: 'admin@mercur-test.com', password: 'supersecret'),
);
final sellers = await mercur.admin.sellers.list(
  const AdminListSellersParams(limit: 10),
);
await mercur.admin.sellers.approve('<seller_id>'); // empty body, restores `open`
```

### Errors

HTTP errors surface as typed `ApiError` (`{type, message}` — e.g.
`invalid_data` 400, `unauthorized` 401, `not_allowed` 403, `not_found` 404),
mapped in the error interceptor:

```dart
try {
  await mercur.customer.products.retrieve('does-not-exist');
} on ApiError catch (e) {
  print('${e.type}: ${e.message}');
}
```

### Conventions

- Lists: `limit`/`offset` query, `{<records>, count, offset, limit}` envelope.
- `fields`: `+x` merges into defaults, `-x` removes, bare **replaces**
  (never mix). A replace-mode response may omit modelled fields — `fromJson`
  requires only `id` and falls back to neutral defaults elsewhere.
- `mercur.clearAuth()` wipes all bearer tokens and the seller scope.

## Coverage

| Surface | Domains |
| --- | --- |
| Customer | auth (login/register), products, sellers, offers, carts (full cycle: line-items, promos, shipping, taxes, customer, complete), shipping-options, regions, orders (+transfer), order-groups, returns (+reasons), catalog (collections, categories, tags, types, attributes, options, variants), misc (currencies, providers, locales), payments (collections + sessions), customers (+addresses) |
| Seller | auth, sellers (+scope/select/me/registration), team (members, invites, profile), details (address, payment/professional), products (+change-request flow, variants, attributes), offers (+batch, inventory-items batch), orders (preview, changes, fulfillments, shipments, commission-lines), money (payments, payouts, payout-accounts), stock (inventory, reservations, locations, shipping, fulfillment-sets), catalog + misc (taxonomy, regions, currencies, channels, reasons, customers, flags, providers, preferences), pricing (price-lists, campaigns), RMA (order-edits, returns, claims, exchanges) |
| Admin | auth, sellers (CRUD, lifecycle approve/suspend/unsuspend/terminate/unterminate, details upserts, members, invites, products) |

Every tranche above was live-verified against a seeded dev backend
(list → retrieve → mutate clean cycles), not just unit-tested.

## Testing

```bash
dart analyze   # must be clean before every commit
dart test      # 134 tests: model round-trips + Dio-stubbed resources
```

Live probes use defines, never hardcoded secrets:

```bash
PUBLISHABLE_KEY=pk_... dart run example/mercur_api_usage.dart
```

## Project layout

```text
lib/
├── mercur_client.dart       # root barrel
└── src/
    ├── configuration.dart   # Configuration {baseUrl, publishableKey, timeouts} + copyWith
    ├── mercur.dart          # Mercur facade: 3 Dios, customer/seller/admin, token setters
    ├── api_error.dart       # typed ApiError
    ├── interceptors/        # store-auth, seller-scope, admin-auth, error mapping
    ├── clients/
    │   ├── customer/        # one *_resource.dart per domain
    │   ├── seller/
    │   └── admin/
    └── models/
        ├── params/          # *Params (lists extend PaginationParams)
        ├── requests/        # *Req
        ├── responses/       # *Res
        ├── headers/         # typed Store/Seller/AdminHeaders (never raw Maps)
        └── enums/
test/                        # one *_test.dart per domain + models_test + resources_test
example/                     # mercur_api_usage.dart (live Store reads)
```

Design rules: one endpoint = up to 3 classes (`{X}Params`/`{X}Req`/`{X}Res`);
string unions are enums; each folder has a barrel re-exported from the root.

## Backend (local dev)

Backend project (`Octocyon`, Mercur): API `http://localhost:9000`
(`/health` → 200), Admin `:9000/dashboard`, Seller `:9000/seller`,
storefront `http://localhost:3002`. Bring-up order: `medusa db:migrate` →
`medusa develop` → `medusa exec ./src/scripts/seed.ts` (migrations first —
`develop` does not run them). Docs source of truth: bundled
`@mercurjs/docs` (`llms.txt` + `content/references/api/**`) plus generated
`packages/api/.mercur/routes.d.ts`.
