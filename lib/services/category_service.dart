import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../constants/app_constants.dart';


class CategoryService {
 // static const String baseUrl = 'https://dummyjson.com';
   static const String baseUrl = AppConstants.apiURL;


  // Fetch all categories
  static Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((category) => Category.fromJson(category)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Fetch categories with product count
  static Future<List<CategoryWithCount>> fetchCategoriesWithCount() async {
    try {
      final categories = await fetchCategories();
      final List<CategoryWithCount> categoriesWithCount = [];

      for (final category in categories) {
        try {
          // Fetch products count for each category
          final response = await http.get(
            Uri.parse('$baseUrl/products/category/${category.slug}?limit=1'),
            headers: {'Content-Type': 'application/json'},
          );

          if (response.statusCode == 200) {
            final Map<String, dynamic> data = json.decode(response.body);
            final int productCount = data['total'] ?? 0;
            
            categoriesWithCount.add(CategoryWithCount(
              category: category,
              productCount: productCount,
            ));
          } else {
            // If failed to get count, add with 0 count
            categoriesWithCount.add(CategoryWithCount(
              category: category,
              productCount: 0,
            ));
          }
        } catch (e) {
          // If error getting count for this category, add with 0 count
          categoriesWithCount.add(CategoryWithCount(
            category: category,
            productCount: 0,
          ));
        }
      }

      return categoriesWithCount;
    } catch (e) {
      throw Exception('Error fetching categories with count: $e');
    }
  }

  // Search categories by name
  static Future<List<Category>> searchCategories(String query) async {
    try {
      final categories = await fetchCategories();
      return categories.where((category) =>
        category.name.toLowerCase().contains(query.toLowerCase()) ||
        category.slug.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      throw Exception('Error searching categories: $e');
    }
  }

  // Get category by slug
  static Future<Category?> getCategoryBySlug(String slug) async {
    try {
      final categories = await fetchCategories();
      return categories.firstWhere(
        (category) => category.slug == slug,
        orElse: () => throw Exception('Category not found'),
      );
    } catch (e) {
      return null;
    }
  }

  // Get popular categories (first few categories)
  static Future<List<Category>> getPopularCategories({int count = 8}) async {
    try {
      final categories = await fetchCategories();
      return categories.take(count).toList();
    } catch (e) {
      throw Exception('Error fetching popular categories: $e');
    }
  }

  // Get categories sorted alphabetically
  static Future<List<Category>> getCategoriesSorted() async {
    try {
      final categories = await fetchCategories();
      categories.sort((a, b) => a.name.compareTo(b.name));
      return categories;
    } catch (e) {
      throw Exception('Error fetching sorted categories: $e');
    }
  }

  // Check if category exists
  static Future<bool> categoryExists(String slug) async {
    try {
      final category = await getCategoryBySlug(slug);
      return category != null;
    } catch (e) {
      return false;
    }
  }
}

// Helper class for categories with product count
class CategoryWithCount {
  final Category category;
  final int productCount;

  CategoryWithCount({
    required this.category,
    required this.productCount,
  });

  // Convenience getters
  String get slug => category.slug;
  String get name => category.name;
  String get displayName => category.displayName;
  String get url => category.url;
}
