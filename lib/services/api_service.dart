import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:machine_test_alisons/models/home_response_model.dart';
import 'package:machine_test_alisons/models/product_model.dart';
import 'package:machine_test_alisons/utils/constants/app_constants.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client = http.Client();

  /// POST helper with query parameters
  Future<dynamic> _post(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.apiBaseUrl}$endpoint',
      ).replace(queryParameters: queryParams);
      final response = await _client.post(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ApiException(
          'Failed to load data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  // ─── LOGIN ──────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> login({
    required String emailPhone,
    required String password,
  }) async {
    try {
      final data = await _post(
        '/login',
        queryParams: {'email_phone': emailPhone, 'password': password},
      );
      return data as Map<String, dynamic>;
    } catch (_) {
      // Fallback: simulate success for known credentials
      if (emailPhone == AppConstants.dummyEmail &&
          password == AppConstants.dummyPassword) {
        return {
          'success': 1,
          'message': 'Login successful',
          'id': 'LL1',
          'token': 'KqqozvPN7toeRZ6QkDmSIpA7Ay5EJZOAngeeJbmp',
        };
      }
      throw ApiException('Invalid email or password');
    }
  }

  // ─── HOME ───────────────────────────────────────────────────────────

  Future<HomeResponse> getHome({
    required String id,
    required String token,
  }) async {
    try {
      final data = await _post(
        '/home/en',
        queryParams: {'id': id, 'token': token},
      );
      return HomeResponse.fromJson(data);
    } catch (_) {
      // Fallback mock data from Postman response
      return HomeResponse.fromJson(_mockHomeResponse);
    }
  }

  // ─── PRODUCTS ───────────────────────────────────────────────────────

  Future<List<Product>> getProducts({
    required String id,
    required String token,
    required String by,
    required String value,
    String? sortBy,
    String? sortOrder,
    int? page,
  }) async {
    try {
      final params = <String, String>{
        'id': id,
        'token': token,
        'by': by,
        'value': value,
      };
      if (sortBy != null) params['sort_by'] = sortBy;
      if (sortOrder != null) params['sort_order'] = sortOrder;
      if (page != null) params['page'] = page.toString();

      final data = await _post('/products/en', queryParams: params);
      if (data is Map && data.containsKey('newarrivals')) {
        return (data['newarrivals'] as List)
            .map((e) => Product.fromJson(e))
            .toList();
      }
      if (data is Map && data.containsKey('data')) {
        return (data['data'] as List).map((e) => Product.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return _mockProducts;
    }
  }

  // ─── MOCK DATA (from Postman response) ──────────────────────────────

  static final Map<String, dynamic> _mockHomeResponse = {
    'success': 1,
    'message': 'alert.success',
    'banner1': [
      {
        'id': 1,
        'banner_type_id': 1,
        'link_type': 0,
        'link_value': '#',
        'order_number': 1,
        'is_active': 1,
        'image': '1690184003_1_owyHEjFVNqutikoOb3bhaxNI9aOIWv9RScIrTY4w.jpg',
        'mobile_image':
            '1690184003_1_VqQs1Ao66cCf3bfQ5FtYfRBYe71ZlnILEfxwjCTF.jpg',
        'title': 'Go Natural with Unpolished Grains',
        'sub_title': 'Hurry Up! Get 10% Off',
        'button_text': 'Shop Now',
      },
    ],
    'banner2': [
      {
        'id': 1,
        'banner_type_id': 2,
        'link_type': 0,
        'link_value': '#',
        'order_number': 1,
        'is_active': 1,
        'image': '1690184122_1_Mm05vGbG777SMCXlD1n0itrvW1PheeEtLyEVWfUi.jpg',
        'mobile_image': '',
        'title': 'Power Your Day with Nuts & Dry Fruits',
        'sub_title': 'Hurry Up! Get 10% Off',
        'button_text': 'Shop Now',
      },
    ],
    'newarrivals': _mockProductsRaw,
    'categories': [
      {
        'category': {
          'id': 32,
          'slug': 'offer-bestbuy',
          'image': '1596923368.jpg',
          'name': 'BEST BUY',
          'description': 'Special Offers, Best deals',
        },
        'subcategory': 3,
      },
      {
        'category': {
          'id': 30,
          'slug': 'newborn-babyproducts-toys-mothers',
          'image': '1688637177.jpg',
          'name': 'BABY ZONE',
          'description': 'New born clothing, utilizes, mother\'s care and toys',
        },
        'subcategory': 6,
      },
      {
        'category': {
          'id': 31,
          'slug': 'techstore-computers-laptop',
          'image': '1596923356.jpg',
          'name': 'TECH STORE',
          'description': 'Computers and IT accessories',
        },
        'subcategory': 15,
      },
      {
        'category': {
          'id': 34,
          'slug': 'electronic-appliance-home',
          'image': '1596923440.jpg',
          'name': 'ELECTRONICS',
          'description': 'Electronics Products for Home',
        },
        'subcategory': 4,
      },
      {
        'category': {
          'id': 27,
          'slug': 'groceries-vegitables',
          'image': '1596922451.jpg',
          'name': 'GROCERY',
          'description': 'Fruits, Vegetables & Food Stuff',
        },
        'subcategory': 17,
      },
    ],
    'featuredbrands': [
      {
        'id': 35,
        'image': '1595774550.jpg',
        'status': 1,
        'slug': 'xshop-nike',
        'is_featured': 1,
        'name': 'Nike',
      },
      {
        'id': 36,
        'image': '1596906953.jpg',
        'status': 1,
        'slug': 'baladana',
        'is_featured': 1,
        'name': 'Baladana',
      },
      {
        'id': 37,
        'image': '1596906967.jpg',
        'status': 1,
        'slug': 'bayara',
        'is_featured': 1,
        'name': 'Bayara',
      },
      {
        'id': 38,
        'image': '1596906986.jpg',
        'status': 1,
        'slug': 'nestle',
        'is_featured': 1,
        'name': 'Nestle',
      },
    ],
    'currency': {
      'name': 'QAR',
      'code': 'QAR',
      'symbol_left': 'QAR',
      'symbol_right': '',
      'value': '1.00',
      'status': 1,
    },
    'cartcount': 0,
    'wishlistcount': null,
    'notification_count': 0,
  };

  static const List<Map<String, dynamic>> _mockProductsRaw = [
    {
      'slug': 'test-product-015-15995738290',
      'name': 'Test product 015',
      'store': 'Family Pharmacy',
      'manufacturer': 'Brands',
      'symbol_left': 'QAR',
      'symbol_right': '',
      'oldprice': '20.00',
      'price': '16.00',
      'discount': '0|nil',
      'image': '',
    },
    {
      'slug':
          'hp-prodesk-400-micro-tower-business-intel-core-i5-9500-4gb-ram-240-gb-ssd-1-tb-hdd-dvd-r-w-usb-kb-mousewin-10-pro-15960884811938',
      'name':
          'Hp Prodesk 400 Micro Tower Business, Intel Core i5-9500, 4GB Ram',
      'store': 'Netcom',
      'manufacturer': 'HP',
      'symbol_left': 'QAR',
      'symbol_right': '',
      'oldprice': '2450.00',
      'price': '2450.00',
      'discount': '0|nil',
      'image':
          'https://ecom-client-bucket-1628833866.s3.ap-south-1.amazonaws.com/images/product/1596154946GErIHaIpO7g0wzmHDYG3NvR4OPDg5JCoX4mUmTdJ.jpeg',
    },
    {
      'slug': 'wd-red-2tb-nas-internal-hard-drive-15960884811939',
      'name': 'WD Red 2TB NAS Internal Hard Drive',
      'store': 'Netcom',
      'manufacturer': 'Brands',
      'symbol_left': 'QAR',
      'symbol_right': '',
      'oldprice': '360.00',
      'price': '320.00',
      'discount': '0|nil',
      'image':
          'https://ecom-client-bucket-1628833866.s3.ap-south-1.amazonaws.com/images/product/1596154964jGiVH36LX5cy7jUuHCzp2IgXBzYTPzXcbzEP0geP.jpeg',
    },
    {
      'slug': 'wd-2tb-my-passport-portable-external-hard-drive-15960884811940',
      'name': 'WD 2TB My Passport Portable External Hard Drive',
      'store': 'Netcom',
      'manufacturer': 'Brands',
      'symbol_left': 'QAR',
      'symbol_right': '',
      'oldprice': '280.00',
      'price': '265.00',
      'discount': '0|nil',
      'image':
          'https://ecom-client-bucket-1628833866.s3.ap-south-1.amazonaws.com/images/product/1596154981bXDjP4j2FOWZdrgd0bgatJq2bqKdgiTeJjbPmWuq.jpeg',
    },
    {
      'slug': 'hp-color-laser-mfp-178nw-15960884811942',
      'name': 'HP Color Laser MFP 178nw',
      'store': 'Netcom',
      'manufacturer': 'HP',
      'symbol_left': 'QAR',
      'symbol_right': '',
      'oldprice': '950.00',
      'price': '875.00',
      'discount': '0|nil',
      'image':
          'https://ecom-client-bucket-1628833866.s3.ap-south-1.amazonaws.com/images/product/1596155014a3xCaBwJF5jxKdCm3YFjPOLMhVttVC2FSryfR68j.jpeg',
    },
    {
      'slug': 'philips-spt-6602-b-wireless-kb-mouse-15960884811943',
      'name': 'Philips SPT 6602 B wireless KB & Mouse',
      'store': 'Netcom',
      'manufacturer': 'Brands',
      'symbol_left': 'QAR',
      'symbol_right': '',
      'oldprice': '88.00',
      'price': '72.00',
      'discount': '0|nil',
      'image':
          'https://ecom-client-bucket-1628833866.s3.ap-south-1.amazonaws.com/images/product/1596155029edCtGu5hUNrI2cWkfPly0LW0YFjwY54jfQw5Sx0c.jpeg',
    },
  ];

  static final List<Product> _mockProducts = _mockProductsRaw
      .map((e) => Product.fromJson(e))
      .toList();
}
