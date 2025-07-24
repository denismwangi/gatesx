import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../constants/app_constants.dart';


class ProductService {
   static const String baseUrl = AppConstants.apiURL;

  // Fetch all products
  static Future<ProductResponse> fetchProducts({int limit = 10, int skip = 0}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products?limit=$limit&skip=$skip'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ProductResponse.fromJson(data);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Fetch products by category
  static Future<ProductResponse> fetchProductsByCategory(
    String category, {
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$category?limit=$limit&skip=$skip'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ProductResponse.fromJson(data);
      } else {
        throw Exception('Failed to load products by category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products by category: $e');
    }
  }

  // Search products
  static Future<ProductResponse> searchProducts(
    String query, {
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/search?q=$query&limit=$limit&skip=$skip'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ProductResponse.fromJson(data);
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }

  // Fetch single product
  static Future<Product> fetchProduct(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  // Fetch products with pagination
  static Future<ProductResponse> fetchProductsWithPagination({
    int page = 1,
    int limit = 10,
  }) async {
    final skip = (page - 1) * limit;
    return fetchProducts(limit: limit, skip: skip);
  }

  // Fetch featured products (first few products)
  static Future<List<Product>> fetchFeaturedProducts({int count = 6}) async {
    try {
      final response = await fetchProducts(limit: count);
      return response.products;
    } catch (e) {
      throw Exception('Error fetching featured products: $e');
    }
  }

  // Fetch products by brand
  static Future<List<Product>> fetchProductsByBrand(String brand) async {
    try {
      final response = await searchProducts(brand);
      return response.products.where((product) => 
        product.brand.toLowerCase().contains(brand.toLowerCase())
      ).toList();
    } catch (e) {
      throw Exception('Error fetching products by brand: $e');
    }
  }

  // Fetch products by price range
  static Future<List<Product>> fetchProductsByPriceRange({
    double? minPrice,
    double? maxPrice,
    int limit = 10,
  }) async {
    try {
      final response = await fetchProducts(limit: limit);
      return response.products.where((product) {
        if (minPrice != null && product.price < minPrice) return false;
        if (maxPrice != null && product.price > maxPrice) return false;
        return true;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products by price range: $e');
    }
  }

  // Fetch products by rating
  static Future<List<Product>> fetchProductsByRating({
    double minRating = 0.0,
    int limit = 10,
  }) async {
    try {
      final response = await fetchProducts(limit: limit);
      return response.products.where((product) => 
        product.rating >= minRating
      ).toList();
    } catch (e) {
      throw Exception('Error fetching products by rating: $e');
    }
  }
}
