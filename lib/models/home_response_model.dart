import 'package:machine_test_alisons/models/banner_model.dart';
import 'package:machine_test_alisons/models/brand_model.dart';
import 'package:machine_test_alisons/models/category_model.dart';
import 'package:machine_test_alisons/models/currency_model.dart';

import 'product_model.dart';

class HomeResponse {
  final int success;
  final String message;
  final List<BannerModel> banner1;
  final List<Product> newArrivals;
  final List<CategoryModel> categories;
  final List<Brand> featuredBrands;
  final Currency currency;

  HomeResponse({
    required this.success,
    required this.message,
    required this.banner1,
    required this.newArrivals,
    required this.categories,
    required this.featuredBrands,
    required this.currency,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      banner1: (json['banner1'] as List?)
          ?.map((e) => BannerModel.fromJson(e))
          .toList() ??
          [],
      newArrivals: (json['newarrivals'] as List?)
          ?.map((e) => Product.fromJson(e))
          .toList() ??
          [],
      categories: (json['categories'] as List?)
          ?.map((e) => CategoryModel.fromJson(e))
          .toList() ??
          [],
      featuredBrands: (json['featuredbrands'] as List?)
          ?.map((e) => Brand.fromJson(e))
          .toList() ??
          [],
      currency: Currency.fromJson(json['currency']),
    );
  }
}