import 'package:dio/dio.dart';

import '../../models/models.dart';

/// Uploads vendeur (`POST /vendor/uploads`).
///
/// Parité dashboard web (`sdk.vendor.uploads.mutate`) : les médias
/// produit et le logo/bannière boutique passent par ici.
/// Champ multipart `files`, auth Bearer membre + permission
/// `products:edit` ou `store:edit` (middlewares backend vérifiés).
/// Réponse `{files: [{id, url}]}` (URLs absolues, provider backend).
class SellerUploadsResource {
  SellerUploadsResource(this._dio);

  final Dio _dio;

  /// `POST /vendor/uploads` — téléverse des fichiers locaux.
  ///
  /// [filePaths] : chemins locaux (ex. `XFile.path` après
  /// `LImageManager.multipleImagePicker` côté app). Le nom envoyé est
  /// le basename du chemin ; le type MIME n'est pas forcé
  /// (`dio` seule dépendance runtime — pas de `http_parser`) :
  /// multer stocke `application/octet-stream`, l'extension d'origine
  /// est conservée et le serveur sert le bon type au téléchargement.
  Future<SellerUploadFilesRes> create({
    required List<String> filePaths,
  }) async {
    final files = [
      for (final path in filePaths)
        await MultipartFile.fromFile(path, filename: _basename(path)),
    ];
    final res = await _dio.post<Map<String, dynamic>>(
      '/vendor/uploads',
      data: FormData.fromMap({'files': files}),
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return SellerUploadFilesRes.fromJson(res.data ?? const {});
  }
}

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final i = normalized.lastIndexOf('/');
  return i < 0 ? path : normalized.substring(i + 1);
}
