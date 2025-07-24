import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

class CartViewModel extends ChangeNotifier {
  Cart? _cart;
  bool _isLoading = false;
  String? _error;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<CartItem> get cartItems => _cart?.products ?? [];
  double get subtotal => _cart?.total ?? 0.0;
  double get discountedTotal => _cart?.discountedTotal ?? 0.0;
  double get totalDiscount => subtotal - discountedTotal;
  int get totalQuantity => _cart?.totalQuantity ?? 0;
  int get totalProducts => _cart?.totalProducts ?? 0;

  // Add product to cart
  Future<void> addToCart(int userId, int productId, int quantity) async {
    try {
      print('🚀 CartViewModel: Starting addToCart - User: $userId, Product: $productId, Qty: $quantity');
      _setLoading(true);
      _error = null;

      final request = AddToCartRequest(
        userId: userId,
        products: [
          CartProduct(id: productId, quantity: quantity),
        ],
      );

      print('🚀 CartViewModel: Calling CartService.addToCart...');
      final cart = await CartService.addToCart(request);
      _cart = cart;
      print('✅ CartViewModel: addToCart successful - Cart has ${_cart!.products.length} items');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print('❌ CartViewModel: addToCart failed - Error: $e');
      notifyListeners();
    } finally {
      _setLoading(false);
      print('🏁 CartViewModel: addToCart completed');
    }
  }

  // Load user's cart
  Future<void> loadUserCart(int userId) async {
    try {
      print('📋 CartViewModel: Starting loadUserCart - User: $userId');
      _setLoading(true);
      _error = null;

      print('📋 CartViewModel: Calling CartService.getUserCart...');
      final cartResponse = await CartService.getUserCart(userId);
      
      if (cartResponse.carts.isNotEmpty) {
        _cart = cartResponse.carts.first;
        print('✅ CartViewModel: loadUserCart successful - Found cart with ${_cart!.products.length} items');
      } else {
        _cart = null;
        print('🟡 CartViewModel: loadUserCart - No carts found for user (empty response)');
      }
      notifyListeners();
    } catch (e) {
      // Don't treat "no cart found" as an error - it's normal for new users
      if (e.toString().contains('404') || e.toString().contains('No cart found')) {
        _cart = null;
        _error = null;
        print('🟡 CartViewModel: loadUserCart - 404 error (normal for new users)');
      } else {
        _error = e.toString();
        print('❌ CartViewModel: loadUserCart failed - Error: $e');
      }
      notifyListeners();
    } finally {
      _setLoading(false);
      print('🏁 CartViewModel: loadUserCart completed');
    }
  }

  // Update cart item quantity
  Future<void> updateCartItemQuantity(int cartId, int productId, int quantity) async {
    if (quantity <= 0) {
      await removeCartItem(cartId, productId);
      return;
    }

    try {
      _setLoading(true);
      _error = null;

      final cart = await CartService.updateCartItem(cartId, productId, quantity);
      _cart = cart;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Remove cart item
  Future<void> removeCartItem(int cartId, int productId) async {
    try {
      _setLoading(true);
      _error = null;

      final cart = await CartService.deleteCartItem(cartId, productId);
      _cart = cart;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Increase item quantity
  Future<void> increaseQuantity(int productId) async {
    if (_cart == null) return;

    final item = _cart!.products.firstWhere(
      (item) => item.id == productId,
      orElse: () => CartItem(
        id: productId,
        title: '',
        price: 0,
        quantity: 0,
        total: 0,
        discountPercentage: 0,
        discountedTotal: 0,
        thumbnail: '',
      ),
    );

    await updateCartItemQuantity(_cart!.id, productId, item.quantity + 1);
  }

  // Decrease item quantity
  Future<void> decreaseQuantity(int productId) async {
    if (_cart == null) return;

    final item = _cart!.products.firstWhere(
      (item) => item.id == productId,
      orElse: () => CartItem(
        id: productId,
        title: '',
        price: 0,
        quantity: 0,
        total: 0,
        discountPercentage: 0,
        discountedTotal: 0,
        thumbnail: '',
      ),
    );

    if (item.quantity > 1) {
      await updateCartItemQuantity(_cart!.id, productId, item.quantity - 1);
    } else {
      await removeCartItem(_cart!.id, productId);
    }
  }

  // Clear cart
  void clearCart() {
    _cart = null;
    _error = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Initialize cart on app start
  Future<void> initializeCart(int userId) async {
    await loadUserCart(userId);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
