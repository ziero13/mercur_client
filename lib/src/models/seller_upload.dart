/// Fichier téléversé via `POST /vendor/uploads`.
///
/// Réponse du workflow `uploadFilesWorkflow` : `{files: [{id, url, ...}]}`.
/// L'URL est absolue, fournie par le provider de fichiers backend
/// (`file-local` + `FILE_BACKEND_URL`).
class SellerUploadedFile {
  const SellerUploadedFile({this.id, this.url});

  final String? id;
  final String? url;

  factory SellerUploadedFile.fromJson(Map<String, dynamic> json) {
    return SellerUploadedFile(
      id: json['id'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (url != null) 'url': url,
    };
  }
}
