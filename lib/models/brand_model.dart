class Brand {
  final int id;
  final String name;
  final String image;
  final String slug;

  Brand({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}