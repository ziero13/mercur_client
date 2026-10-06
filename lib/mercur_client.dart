/// mercur_client — typed Dart client for the Mercur marketplace API.
///
/// Three entry points mirroring the three HTTP surfaces:
/// `Mercur.customer` (`/store/*`), `Mercur.seller` (`/vendor/*`),
/// `Mercur.admin` (`/admin/*`). Zero `Map` in the public API: every
/// query, body, response and header set is a typed class with
/// hand-written `toJson`/`fromJson`.
library;

export 'src/mercur.dart';
export 'src/configuration.dart';
export 'src/api_error.dart';
export 'src/interceptors/interceptors.dart';
export 'src/clients/clients.dart';
export 'src/models/models.dart';
