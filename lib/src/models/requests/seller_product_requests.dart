import '../seller_product.dart';

/// One `attributes[]` entry of `POST /vendor/products` (vérifié :
/// `UnifiedProductAttributeInput` — forme référençant un attribut
/// existant OU inline).
class SellerCreateProductAttribute {
  const SellerCreateProductAttribute({
    this.id,
    this.valueIds = const [],
    this.value,
    this.title,
    this.type,
    this.values = const [],
    this.isVariantAxis,
    this.isFilterable,
    this.isRequired,
  });

  /// Référence un attribut existant (`{id, value_ids[]?, value?}`).
  final String? id;
  final List<String> valueIds;
  final Object? value;

  /// Attribut inline (`{title, type?, values[]?, value?, ...}`).
  final String? title;
  final String? type;
  final List<String> values;
  final bool? isVariantAxis;
  final bool? isFilterable;
  final bool? isRequired;

  Map<String, dynamic> toJson() {
    if (id != null) {
      return {
        'id': id,
        if (valueIds.isNotEmpty) 'value_ids': valueIds,
        if (value != null) 'value': value,
      };
    }
    return {
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (values.isNotEmpty) 'values': values,
      if (value != null) 'value': value,
      if (isVariantAxis != null) 'is_variant_axis': isVariantAxis,
      if (isFilterable != null) 'is_filterable': isFilterable,
      if (isRequired != null) 'is_required': isRequired,
    };
  }
}

/// Body of `POST /vendor/products`.
class SellerCreateProductReq {
  const SellerCreateProductReq({
    required this.title,
    this.subtitle,
    this.description,
    this.status,
    this.isGiftcard,
    this.discountable,
    this.thumbnail,
    this.handle,
    this.imageUrls = const [],
    this.typeId,
    this.collectionId,
    this.categoryIds = const [],
    this.tagIds = const [],
    this.attributes = const [],
    this.variants = const [],
  });

  final String title;
  final String? subtitle;
  final String? description;
  final String? status;
  final bool? isGiftcard;
  final bool? discountable;
  final String? thumbnail;
  final String? handle;
  final List<String> imageUrls;
  final String? typeId;
  final String? collectionId;

  /// `categories: [{id}]` / `tags: [{id}]` (parité web).
  final List<String> categoryIds;
  final List<String> tagIds;

  /// Attributs initiaux (référencés ou inline, parité web).
  final List<SellerCreateProductAttribute> attributes;

  /// Variants initiaux (génération cartésienne, parité web).
  final List<SellerVariantReq> variants;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (isGiftcard != null) 'is_giftcard': isGiftcard,
      if (discountable != null) 'discountable': discountable,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (handle != null) 'handle': handle,
      if (imageUrls.isNotEmpty)
        'images': imageUrls.map((u) => {'url': u}).toList(),
      if (typeId != null) 'type_id': typeId,
      if (collectionId != null) 'collection_id': collectionId,
      if (categoryIds.isNotEmpty)
        'categories': categoryIds.map((id) => {'id': id}).toList(),
      if (tagIds.isNotEmpty)
        'tags': tagIds.map((id) => {'id': id}).toList(),
      if (attributes.isNotEmpty)
        'attributes': attributes.map((a) => a.toJson()).toList(),
      if (variants.isNotEmpty)
        'variants': variants.map((v) => v.toJson()).toList(),
    };
  }
}

/// Body of `POST /vendor/products/:id` (staged as a change request).
class SellerUpdateProductReq {
  const SellerUpdateProductReq({
    this.title,
    this.subtitle,
    this.description,
    this.discountable,
    this.isGiftcard,
    this.thumbnail,
    this.handle,
    this.images = const [],
    this.typeId,
    this.collectionId,
    this.categoryIds = const [],
    this.tagIds = const [],
    this.weight,
    this.length,
    this.height,
    this.width,
    this.hsCode,
    this.midCode,
    this.originCountry,
    this.material,
  });

  final String? title;
  final String? subtitle;
  final String? description;
  final bool? discountable;
  final bool? isGiftcard;
  final String? thumbnail;
  final String? handle;

  /// Remplacement complet de la galerie (`images: [{id?, url}]`,
  /// vérifié : `UpdateProduct.images`, parité web).
  final List<SellerProductImage> images;
  final String? typeId;
  final String? collectionId;
  final List<String> categoryIds;
  final List<String> tagIds;
  final num? weight;
  final num? length;
  final num? height;
  final num? width;
  final String? hsCode;
  final String? midCode;
  final String? originCountry;
  final String? material;

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (description != null) 'description': description,
      if (discountable != null) 'discountable': discountable,
      if (isGiftcard != null) 'is_giftcard': isGiftcard,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (handle != null) 'handle': handle,
      if (images.isNotEmpty)
        'images': images.map((i) => i.toJson()).toList(),
      if (typeId != null) 'type_id': typeId,
      if (collectionId != null) 'collection_id': collectionId,
      if (categoryIds.isNotEmpty)
        'categories': categoryIds.map((id) => {'id': id}).toList(),
      if (tagIds.isNotEmpty)
        'tags': tagIds.map((id) => {'id': id}).toList(),
      if (weight != null) 'weight': weight,
      if (length != null) 'length': length,
      if (height != null) 'height': height,
      if (width != null) 'width': width,
      if (hsCode != null) 'hs_code': hsCode,
      if (midCode != null) 'mid_code': midCode,
      if (originCountry != null) 'origin_country': originCountry,
      if (material != null) 'material': material,
    };
  }
}

/// Body of variant create/update on
/// `/vendor/products/:id/variants[/:variant_id]` (staged as a change
/// request; 202 + `product_change`).
class SellerVariantReq {
  const SellerVariantReq({
    this.title,
    this.sku,
    this.ean,
    this.upc,
    this.barcode,
    this.thumbnail,
    this.variantRank,
    this.weight,
    this.length,
    this.height,
    this.width,
    this.hsCode,
    this.midCode,
    this.originCountry,
    this.material,
    this.options = const {},
  });

  final String? title;
  final String? sku;
  final String? ean;
  final String? upc;
  final String? barcode;
  final String? thumbnail;
  final int? variantRank;
  final num? weight;
  final num? length;
  final num? height;
  final num? width;
  final String? hsCode;
  final String? midCode;
  final String? originCountry;
  final String? material;

  /// `options: {axe: valeur}` (génération cartésienne, parité web).
  final Map<String, String> options;

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (sku != null) 'sku': sku,
      if (ean != null) 'ean': ean,
      if (upc != null) 'upc': upc,
      if (barcode != null) 'barcode': barcode,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (variantRank != null) 'variant_rank': variantRank,
      if (weight != null) 'weight': weight,
      if (length != null) 'length': length,
      if (height != null) 'height': height,
      if (width != null) 'width': width,
      if (hsCode != null) 'hs_code': hsCode,
      if (midCode != null) 'mid_code': midCode,
      if (originCountry != null) 'origin_country': originCountry,
      if (material != null) 'material': material,
      if (options.isNotEmpty) 'options': Map.of(options),
    };
  }
}

/// One `add` entry of `POST …/attributes/batch` (referencing form).
class SellerAttributeAdd {
  const SellerAttributeAdd({this.id, this.valueIds = const [], this.value});

  final String? id;
  final List<String> valueIds;
  final Object? value;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (valueIds.isNotEmpty) 'value_ids': valueIds,
      if (value != null) 'value': value,
    };
  }
}

/// One `update` entry of `POST …/attributes/batch`.
class SellerAttributeUpdate {
  const SellerAttributeUpdate({required this.id, this.valueIds, this.value});

  final String id;
  final List<String>? valueIds;
  final Object? value;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (valueIds != null) 'value_ids': valueIds,
      if (value != null) 'value': value,
    };
  }
}

/// Body of `POST /vendor/products/:id/attributes/batch`.
class SellerAttributesBatchReq {
  const SellerAttributesBatchReq({
    this.add = const [],
    this.remove = const [],
    this.update = const [],
  });

  final List<SellerAttributeAdd> add;
  final List<String> remove;
  final List<SellerAttributeUpdate> update;

  Map<String, dynamic> toJson() {
    return {
      if (add.isNotEmpty) 'add': add.map((a) => a.toJson()).toList(),
      if (remove.isNotEmpty) 'remove': remove,
      if (update.isNotEmpty) 'update': update.map((u) => u.toJson()).toList(),
    };
  }
}
