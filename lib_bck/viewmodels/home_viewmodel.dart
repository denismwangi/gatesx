import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/product_service.dart';
import '../services/category_service.dart';

class HomeViewModel extends ChangeNotifier {
  // State variables
  List<Product> _products = [];
  List<Product> _recentlyViewed = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<Product> get products => _products;
  List<Product> get recentlyViewed => _recentlyViewed;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Featured products (first 6 products)
  List<Product> get featuredProducts => _products.take(6).toList();

  // Constructor
  HomeViewModel() {
    loadInitialData();
  }

  // Load initial data
  Future<void> loadInitialData() async {
    await Future.wait([
      fetchProducts(),
      fetchCategories(),
    ]);
  }

  // Fetch products
  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      _products.clear();
    }

    _setLoading(true);
    _setError(null);

    try {
      final response = await ProductService.fetchProducts(limit: 30);
      _products = response.products;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      _categories = await CategoryService.fetchCategories();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Search products
  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      await fetchProducts();
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      final response = await ProductService.searchProducts(query);
      _products = response.products;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Filter products by category
  Future<void> filterByCategory(String categorySlug) async {
    if (categorySlug.isEmpty) {
      // Fetch all products when "All" is selected
      await fetchProducts();
      return;
    }
    
    _setLoading(true);
    _setError(null);

    try {
      final response = await ProductService.fetchProductsByCategory(categorySlug);
      _products = response.products;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add product to recently viewed
  void addToRecentlyViewed(Product product) {
    // Remove if already exists
    _recentlyViewed.removeWhere((p) => p.id == product.id);
    
    // Add to beginning
    _recentlyViewed.insert(0, product);
    
    // Keep only last 10 items
    if (_recentlyViewed.length > 10) {
      _recentlyViewed = _recentlyViewed.take(10).toList();
    }
    
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    fetchProducts();
  }

  // Refresh all data
  Future<void> refresh() async {
    await loadInitialData();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
