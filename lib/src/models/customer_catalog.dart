// Store catalog reads: collections, categories, tags, types,
// attributes, options, variants (`GET /store/*`, read-only).
//
// Only `id` is required everywhere — partial `fields` selections fall
// back to neutral defaults (see AGENTS.md).

/// Store collection.
class CustomerCollection {
  const CustomerCollection({
    required this.id,
    this.title,
    this.handle,
  });

  final String id;
  final String? title;
  final String? handle;

  factory CustomerCollection.fromJson(Map<String, dynamic> json) {
    return CustomerCollection(
      id: json['id'] as String,
      title: json['title'] as String?,
      handle: json['handle'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (title != null) 'title': title,
      if (handle != null) 'handle': handle,
    };
  }
}

/// Store product category.
class CustomerCategory {
  const CustomerCategory({
    required this.id,
    this.name,
    this.handle,
    this.description,
    this.parentCategoryId,
  });

  final String id;
  final String? name;
  final String? handle;
  final String? description;
  final String? parentCategoryId;

  factory CustomerCategory.fromJson(Map<String, dynamic> json) {
    return CustomerCategory(
      id: json['id'] as String,
      name: json['name'] as String?,
      handle: json['handle'] as String?,
      description: json['description'] as String?,
      parentCategoryId: json['parent_category_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (handle != null) 'handle': handle,
      if (description != null) 'description': description,
      if (parentCategoryId != null)
        'parent_category_id': parentCategoryId,
    };
  }
}

/// Store product tag.
class CustomerProductTag {
  const CustomerProductTag({
    required this.id,
    this.value,
  });

  final String id;
  final String? value;

  factory CustomerProductTag.fromJson(Map<String, dynamic> json) {
    return CustomerProductTag(
      id: json['id'] as String,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (value != null) 'value': value,
    };
  }
}

/// Store product type.
class CustomerProductType {
  const CustomerProductType({
    required this.id,
    this.value,
  });

  final String id;
  final String? value;

  factory CustomerProductType.fromJson(Map<String, dynamic> json) {
    return CustomerProductType(
      id: json['id'] as String,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (value != null) 'value': value,
    };
  }
}

/// Store product attribute (global, active).
class CustomerProductAttribute {
  const CustomerProductAttribute({
    required this.id,
    this.name,
    this.handle,
  });

  final String id;
  final String? name;
  final String? handle;

  factory CustomerProductAttribute.fromJson(Map<String, dynamic> json) {
    return CustomerProductAttribute(
      id: json['id'] as String,
      name: json['name'] as String?,
      handle: json['handle'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (handle != null) 'handle': handle,
    };
  }
}

/// One value of a store product option.
class CustomerProductOptionValue {
  const CustomerProductOptionValue({
    required this.id,
    this.value,
  });

  final String id;
  final String? value;

  factory CustomerProductOptionValue.fromJson(Map<String, dynamic> json) {
    return CustomerProductOptionValue(
      id: json['id'] as String,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (value != null) 'value': value,
    };
  }
}

/// Store product option with its values.
class CustomerProductOption {
  const CustomerProductOption({
    required this.id,
    this.title,
    this.values = const [],
  });

  final String id;
  final String? title;
  final List<CustomerProductOptionValue> values;

  factory CustomerProductOption.fromJson(Map<String, dynamic> json) {
    final rawValues = json['values'];
    return CustomerProductOption(
      id: json['id'] as String,
      title: json['title'] as String?,
      values: rawValues is List
          ? rawValues
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerProductOptionValue.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (title != null) 'title': title,
      'values': values.map((v) => v.toJson()).toList(),
    };
  }
}
