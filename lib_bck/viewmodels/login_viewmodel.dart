import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  User? user;
  String? _accessToken;

  // Getter for access token
  String? get accessToken => _accessToken;
  
  // Getter for user's full name
  String get userFullName {
    if (user != null) {
      return '${user!.firstName} ${user!.lastName}'.trim();
    }
    return 'Guest User';
  }
  
  // Getter for user's first name
  String get userFirstName {
    if (user != null && user!.firstName.isNotEmpty) {
      return user!.firstName;
    }
    return 'Guest';
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': email, 'password': password}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user = User.fromJson(data);
        _accessToken = user?.accessToken;
        
        // Fetch detailed user information after successful login
        if (_accessToken != null) {
          await fetchCurrentUser();
        }
        
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = 'Login fehlgeschlagen. Bitte überprüfe deine Daten.';
      }
    } catch (e) {
      errorMessage = 'Netzwerkfehler: $e';
    }
    
    isLoading = false;
    notifyListeners();
    return false;
  }
  
  // Fetch current user details using access token
  Future<void> fetchCurrentUser() async {
    if (_accessToken == null) {
      errorMessage = 'No access token available';
      notifyListeners();
      return;
    }
    
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/auth/me'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Update user with detailed information from /auth/me endpoint
        user = User.fromJson({
          ...data,
          'accessToken': _accessToken,
          'refreshToken': user?.refreshToken ?? '',
        });
        notifyListeners();
      } else {
        print('Failed to fetch user details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
  
  // Logout method
  void logout() {
    user = null;
    _accessToken = null;
    errorMessage = null;
    notifyListeners();
  }
  
  // Check if user is logged in
  bool get isLoggedIn => user != null && _accessToken != null;
}
