import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../constants/app_constants.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  User? user;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiURL}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': email, 'password': password}),
      );
      print('Response: $response');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user = User.fromJson(data);
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = 'Login failed.';
      }
    } catch (e) { 
      errorMessage = 'Login failed: $e';
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
}
