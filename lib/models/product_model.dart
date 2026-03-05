class Product {
  final String slug;
  final String name;
  final String store;
  final String manufacturer;
  final String price;
  final String oldPrice;
  final String image;

  Product({
    required this.slug,
    required this.name,
    required this.store,
    required this.manufacturer,
    required this.price,
    required this.oldPrice,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      store: json['store'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      price: json['price'] ?? '',
      oldPrice: json['oldprice'] ?? '',
      image: json['image'] ?? '',
    );
  }
}