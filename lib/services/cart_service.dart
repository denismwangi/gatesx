import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';
import '../constants/app_constants.dart';

class CartService {
  static const String baseUrl = AppConstants.apiURL;

  // Add products to cart
  static Future<Cart> addToCart(AddToCartRequest request) async {
    try {
      final url = '$baseUrl/carts/add';
      final requestBody = json.encode(request.toJson());
      
      print('🛒 ADD TO CART REQUEST:');
      print('   URL: $url');
      print('   Method: POST');
      print('   Headers: {"Content-Type": "application/json"}');
      print('   Body: $requestBody');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print('🛒 ADD TO CART RESPONSE:');
      print('   Status Code: ${response.statusCode}');
      print('   Headers: ${response.headers}');
      print('   Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ ADD TO CART SUCCESS - Parsed data: $data');
        return Cart.fromJson(data);
      } else {
        print('❌ ADD TO CART FAILED - Status: ${response.statusCode}');
        throw Exception('Failed to add to cart: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 ADD TO CART EXCEPTION: $e');
      throw Exception('Error adding to cart: $e');
    }
  }

  // Get user's cart
  static Future<CartResponse> getUserCart(int userId) async {
    try {
      final url = '$baseUrl/carts/user/$userId';
      
      print('📋 GET USER CART REQUEST:');
      print('   URL: $url');
      print('   Method: GET');
      print('   Headers: {"Content-Type": "application/json"}');
      print('   User ID: $userId');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('📋 GET USER CART RESPONSE:');
      print('   Status Code: ${response.statusCode}');
      print('   Headers: ${response.headers}');
      print('   Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ GET USER CART SUCCESS - Parsed data: $data');
        return CartResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        print('🟡 GET USER CART 404 - User has no cart yet, returning empty cart');
        return CartResponse(
          carts: [],
          total: 0,
          skip: 0,
          limit: 1,
        );
      } else {
        print('❌ GET USER CART FAILED - Status: ${response.statusCode}');
        throw Exception('Failed to load user cart: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 GET USER CART EXCEPTION: $e');
      throw Exception('Error fetching user cart: $e');
    }
  }

  // Update cart item quantity
  static Future<Cart> updateCartItem(int cartId, int productId, int quantity) async {
    try {
      final url = '$baseUrl/carts/$cartId';
      final requestBody = json.encode({
        'merge': false,
        'products': [
          {
            'id': productId,
            'quantity': quantity,
          }
        ]
      });
      
      print('✏️ UPDATE CART ITEM REQUEST:');
      print('   URL: $url');
      print('   Method: PUT');
      print('   Headers: {"Content-Type": "application/json"}');
      print('   Cart ID: $cartId');
      print('   Product ID: $productId');
      print('   Quantity: $quantity');
      print('   Body: $requestBody');
      
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print('✏️ UPDATE CART ITEM RESPONSE:');
      print('   Status Code: ${response.statusCode}');
      print('   Headers: ${response.headers}');
      print('   Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ UPDATE CART ITEM SUCCESS - Parsed data: $data');
        return Cart.fromJson(data);
      } else {
        print('❌ UPDATE CART ITEM FAILED - Status: ${response.statusCode}');
        throw Exception('Failed to update cart: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 UPDATE CART ITEM EXCEPTION: $e');
      throw Exception('Error updating cart: $e');
    }
  }

  // Delete cart item
  static Future<Cart> deleteCartItem(int cartId, int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/carts/$cartId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Cart.fromJson(data);
      } else {
        throw Exception('Failed to delete cart item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting cart item: $e');
    }
  }

  // Get all carts
  static Future<CartResponse> getAllCarts({int limit = 10, int skip = 0}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/carts?limit=$limit&skip=$skip'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CartResponse.fromJson(data);
      } else {
        throw Exception('Failed to load carts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching carts: $e');
    }
  }
}
