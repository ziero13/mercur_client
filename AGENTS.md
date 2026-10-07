# AGENTS.md — mercur_client

> Client HTTP Dart pur pour l'API du marketplace Mercur (backend : projet `Octocyon`).
> Repo GitHub : accès via compte `ziero13` (gh CLI authentifié).

## Objectif

Package Dart (pas Flutter) exposant **3 points d'entrée**, miroir des 3 surfaces HTTP de Mercur :

| Entrée   | Surface  | Audience  | Authentification                                    |
|----------|----------|-----------|-----------------------------------------------------|
| customer | `/store/*`  | Acheteur  | `x-publishable-api-key` toujours ; Bearer client si connecté |
| seller   | `/vendor/*` | Vendeur   | Bearer membre + scoping `x-seller-id`               |
| admin    | `/admin/*`  | Opérateur | Bearer user                                         |

## Librairies

- **`dio ^5.11.1` — SEULE dépendance runtime.** Pas de `retrofit`, pas de `build_runner`,
  pas de `json_serializable` : les `toJson`/`fromJson` sont écrits à la main.
- Dév : `test`, `lints` (squelette `dart create`).
- Référence d'inspiration : `enocben/lycaon_packages/packages/medusa-js-dart`
  (clone local de lecture : `~/lycaon-ref`). On en reprend : 3 Dio par surface,
  1 resource par domaine, `models/` découpé en `params/requests/responses/enums`,
  barrels par dossier, intercepteurs. On S'EN ÉCARTE sur : Dio direct sans génération,
  headers typés (jamais de `Map` brute), surface vendeur avec ses vraies routes
  (la réf. réutilise les resources admin dans `Vendor` — ne pas reproduire).

## Règles non négociables

1. **Zéro `Map` dans l'API publique.** Query params, bodies, responses ET headers sont
   des classes typées. Un `Map<String, dynamic>` n'apparaît qu'à la frontière Dio,
   à l'intérieur des resources.
2. **Chaque classe a `toJson` + `fromJson`** (manuels, pas générés).
3. **1 endpoint = jusqu'à 3 classes** : `{X}Params` (query), `{X}Req` (body), `{X}Res` (réponse).
4. **Unions string → `enum`** dans `models/enums/` (ex. `SellerStatus.open/pendingApproval/...`).
5. **Chaque dossier a son barrel** (`clients.dart`, `params.dart`, ...) ré-exporté par
   `lib/mercur_client.dart`. Tout nouveau fichier doit y être exporté.
6. **Avant toute route non triviale, lire la doc versionnée** :
   `/home/contabo/Octocyon/node_modules/@mercurjs/docs/llms.txt` puis la page
   `content/...` correspondante. Ne jamais deviner un endpoint — vérifier aussi
   `packages/api/.mercur/routes.d.ts` (route map générée) et le code Medusa si doute.

## Layout

```
lib/
├── mercur_client.dart            # barrel racine
└── src/
    ├── configuration.dart        # Configuration {baseUrl, publishableKey, timeouts} + copyWith
    ├── mercur.dart               # Mercur : construit les 3 Dio, expose customer/seller/admin,
    │                             # setUserToken()/setMemberToken()/setCustomerToken()/setSellerId()
    ├── interceptors/             # auth_interceptor, seller_scope_interceptor, error_interceptor
    ├── clients/
    │   ├── customer/             # 1 fichier/domaine : products_resource, sellers_resource,
    │   │                         # offers_resource, carts_resource (cycle complet :
    │   │                         # retrieve/update/line-items/promos/shipping/taxes/
    │   │                         # customer/complete), shipping_options_resource,
    │   │                         # regions_resource, orders_resource (+transfer),
    │   │                         # returns_resource (+return-reasons),
    │   │                         # catalog_resource (collections/categories/tags/
    │   │                         # types/attributes/options/variants),
    │   │                         # misc_resource (currencies/providers/locales),
    │   │                         # payments_resource (payment-collections +
    │   │                         # payment-sessions : checkout payment step),
    │   │                         # customers_resource, auth_resource...
    │   ├── seller/               # offers, products, orders, sellers, members, payouts,
    │   │                         # payout_accounts, product_attributes, product_variants, auth...
    │   └── admin/                # auth_resource, sellers_resource (CRUD, lifecycle :
    │                             # approve/suspend/unsuspend/terminate/unterminate,
    │                             # address/payment/professional upserts, members,
    │                             # invites, products)...
    └── models/
        ├── models.dart           # entités partagées : Seller, Offer, Product, Cart, OrderGroup...
        ├── params/               # *Params (étendent PaginationParams quand liste)
        ├── requests/             # *Req
        ├── responses/            # *Res
        ├── headers/              # StoreHeaders, SellerHeaders, AdminHeaders (+ toHeaders())
        └── enums/
```

## Nomenclature

- Resources : fichier `<domaine>_resource.dart`, classe `{Prefix}{Domaine}Resource`
  (`CustomerSellersResource`, `SellerOffersResource`, `AdminSellersResource`),
  méthodes `list / retrieve / create / update / delete / ...` + cas spéciaux
  (`complete`, `select`, `approve`...).
- Modèles : `{Prefix}{Entité}` (`CustomerProduct`... ou partagé `Seller`, `Offer`
  si identique sur les 3 surfaces), champs en `camelCase` mappés vers `snake_case` JSON.
- Fichiers modèles : `snake_case` miroir de la classe.

## Conventions API (vérifiées en live contre le backend local)

- JSON partout. Listes : query `limit/offset` (+ `order`, `q`, `fields`, filtres),
  enveloppe `{<ressources>, count, offset, limit}`.
- `fields` : `+x` ajoute aux défauts, `-x` retire, nu **remplace** (ne jamais mélanger).
- Erreurs : `{type, message}` (`invalid_data` 400, `unauthorized` 401, `not_allowed` 403,
  `not_found` 404) → mapper vers `ApiError` typée dans `error_interceptor`.
- Auth : `POST /auth/user/emailpass`, `/auth/member/emailpass`,
  `/auth/customer/emailpass` → `{token}` (JWT : `actor_id`, `actor_type`).
- **Inscription client en 3 temps** : `POST /auth/customer/emailpass/register` → token
  → `POST /store/customers` (avec Bearer) → login. Exposer comme une seule méthode
  `registerCustomer()`. (`POST /store/customers` anonyme = 401, vérifié dans le code.)
- `POST /auth/customer/emailpass/register` rejette les requêtes déjà authentifiées
  (`already authenticated as a customer`, 400) : `registerCustomer()` exige une
  session vierge (client frais ou `clearAuth()`). Vérifié en live le 2026-10-06.
- Scoping vendeur : header `x-seller-id` OU session via `POST /vendor/sellers/select`.
  Sans scoping, `GET /vendor/sellers` renvoie les memberships (choix du vendeur).
- **Quirks encodés, pas contournés à l'usage** :
  - `POST /store/payment-collections` est idempotent (retourne la collection
    existante du panier) ; les deux POST répondent `{payment_collection}`.
    Vérifié en live le 2026-10-07.
  - `GET /store/order-groups` sans `fields` → 400 : `fields` restreints par défaut.
  - `POST /store/carts/:id/line-items` prend `offer_id`, jamais `variant_id`.
  - `POST /store/carts/:id/complete` splitte en commandes par vendeur (order group).
  - `POST /store/carts/:id/taxes` exige un pays (`shipping_address.country_code`), 400 sinon.
  - `GET /store/shipping-options` renvoie une MAP `{seller_id: [...]}` (vide si panier vide) ;
    `POST …/:id/calculate` → 500 serveur sur le seed (bug backend, client inchangé).
  - `GET /store/product-variants` exige une clé publishable à sales channel (400 sinon).
  - `GET /store/locales` → 404 sauf flag backend `translation` actif.
  - `POST /store/orders/:id/transfer/request` sur sa propre commande → 400
    (`already belongs to customer`) : cycle accept/decline à re-prober sur un vrai transfert.
  - `fields` en mode replace peut omettre des champs modélisés : `fromJson`
    n'exige que `id` (le reste retombe sur défauts neutres), et les variants
    sans `id` sont ignorés. Vérifié en live le 2026-10-06.
  - `GET /admin/sellers/:id/members` sans `fields` ne renvoie pas de `rbac_role`
    nested (flat `role_id` / `member_id`, comme vendor) : les deux formes décodent.
    Vérifié en live le 2026-10-07.
  - `POST /admin/sellers/:id/members/invite` répond 201 `{member_invite}` ;
    `GET /admin/sellers/:id/products` → `count: 0` sur tout le seed (enveloppe
    vide vérifiée, détail à re-prober au premier vrai produit). Vérifié en live
    le 2026-10-07.

## Backend local (dev)

- API : `http://localhost:9000` (`/health` → 200). Admin : `:9000/dashboard`.
  Vendeur : `:9000/seller`. Storefront : `http://localhost:3002`.
- Projet : `/home/contabo/Octocyon`. Serveurs dev tournent en background (API + storefront).
- DB `octocyon` sur le Postgres payswitch partagé (`127.0.0.1:5432`, ne pas toucher
  aux autres bases). Redis partagé aussi (mode dégradé accepté en dev).
- `.env` backend : `Octocyon/packages/api/.env` (secrets dedans — ne jamais les afficher).
- Comptes dev (`supersecret` partout) : `admin@mercur-test.com`, `seller@mercur.dev`,
  `kickz@mercur.dev`, `trailhead@mercur.dev`. Client test : `dart-test@example.com`.
- JWT_SECRET/cookies : valeurs `supersecret` de dev, ne pas durcir ici.

## Tests

- Chaque classe : test round-trip `fromJson(toJson(x)) == x`.
- Chaque resource : test sur Dio mocké vérifiant path + query + body + headers sérialisés.
- `dart analyze` propre avant chaque commit.

## Workflow

- Implémenter par tranches (1 domaine × 1 surface), en partant des `models` puis la resource.
- Décision qui change → mettre à jour ce fichier d'abord.
- Commit : rebase avant modif, push direct, messages courts.
