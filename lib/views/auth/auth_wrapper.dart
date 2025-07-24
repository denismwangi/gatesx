import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../home/home_screen.dart';
import 'screens/login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<LoginViewModel, CartViewModel>(
      builder: (context, loginViewModel, cartViewModel, child) {
        // Initialize cart when user logs in
        if (loginViewModel.isLoggedIn && loginViewModel.user != null) {
          print('🔑 AuthWrapper: User logged in - ID: ${loginViewModel.user!.id}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print('🔑 AuthWrapper: Initializing cart for user ${loginViewModel.user!.id}');
            cartViewModel.initializeCart(loginViewModel.user!.id);
          });
          return const HomeScreen();
        } else {
          print('🔑 AuthWrapper: User not logged in, showing login screen');
          return const LoginScreen();
        }
      },
    );
  }
}
