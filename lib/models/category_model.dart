class CategoryModel {
  final Category category;
  final int subcategory;

  CategoryModel({
    required this.category,
    required this.subcategory,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: Category.fromJson(json['category']),
      subcategory: json['subcategory'] ?? 0,
    );
  }
}

class Category {
  final int id;
  final String slug;
  final String name;
  final String image;
  final String description;

  Category({
    required this.id,
    required this.slug,
    required this.name,
    required this.image,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}