import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/login_viewmodel.dart';
import '../../../viewmodels/cart_viewmodel.dart';
import '../../cart/cart_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      loginViewModel.user?.image.isNotEmpty == true
                          ? loginViewModel.user!.image
                          : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: loginViewModel.user?.image.isEmpty == true
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              
              // Greeting Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello ${loginViewModel.userFirstName}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      loginViewModel.isLoggedIn
                          ? 'Welcome to Ssense'
                          : 'Please login to continue',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
          
          // Notification and Bag Icons
          Row(
            children: [
              // Login/Logout Button (for testing)
              GestureDetector(
                onTap: () async {
                  if (loginViewModel.isLoggedIn) {
                    loginViewModel.logout();
                  } else {
                    // Demo login with test credentials
                    await loginViewModel.login('emilys', 'emilyspass');
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: loginViewModel.isLoggedIn 
                        ? Colors.red[100] 
                        : Colors.green[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    loginViewModel.isLoggedIn 
                        ? Icons.logout 
                        : Icons.login,
                    color: loginViewModel.isLoggedIn 
                        ? Colors.red[700] 
                        : Colors.green[700],
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black54,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Consumer<CartViewModel>(
                    builder: (context, cartViewModel, child) {
                      final itemCount = cartViewModel.totalQuantity;
                      return Stack(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ),
                          if (itemCount > 0)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '$itemCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
      },
    );
  }
}
