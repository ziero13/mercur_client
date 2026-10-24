import '../seller_upload.dart';

/// Réponse de `POST /vendor/uploads`.
class SellerUploadFilesRes {
  const SellerUploadFilesRes({this.files = const []});

  final List<SellerUploadedFile> files;

  factory SellerUploadFilesRes.fromJson(Map<String, dynamic> json) {
    final raw = json['files'];
    return SellerUploadFilesRes(
      files: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .map(SellerUploadedFile.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'files': files.map((f) => f.toJson()).toList(),
    };
  }
}
