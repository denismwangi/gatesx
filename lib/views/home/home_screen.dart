import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import 'widgets/profile_header.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/promotional_slider.dart';
import 'widgets/category_chips.dart';
import 'widgets/recent_viewed_section.dart';
import 'widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return RefreshIndicator(
              onRefresh: viewModel.refresh,
              child: CustomScrollView(
                slivers: [
                  // Profile Header
                  const SliverToBoxAdapter(
                    child: ProfileHeader(),
                  ),
                  
                  // Search Bar
                  SliverToBoxAdapter(
                    child: SearchBarWidget(
                      onSearch: viewModel.searchProducts,
                      searchQuery: viewModel.searchQuery,
                    ),
                  ),
                  
                  // Promotional Slider
                  const SliverToBoxAdapter(
                    child: PromotionalSlider(),
                  ),
                  
                  // Category Chips
                  SliverToBoxAdapter(
                    child: CategoryChips(
                      categories: viewModel.categories,
                      onCategorySelected: viewModel.filterByCategory,
                    ),
                  ),
                  
                  // Recent Viewed Section
                  if (viewModel.recentlyViewed.isNotEmpty)
                    SliverToBoxAdapter(
                      child: RecentViewedSection(
                        products: viewModel.recentlyViewed,
                        onProductTap: (product) {
                          // Navigate to product detail
                          _navigateToProductDetail(context, product, viewModel);
                        },
                      ),
                    ),
                  
                  // Products Grid
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: viewModel.isLoading
                        ? const SliverToBoxAdapter(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : viewModel.error != null
                            ? SliverToBoxAdapter(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Something went wrong',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        viewModel.error!,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          viewModel.clearError();
                                          viewModel.fetchProducts(refresh: true);
                                        },
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SliverGrid(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final product = viewModel.products[index];
                                    return ProductCard(
                                      product: product,
                                      onTap: () => _navigateToProductDetail(context, product, viewModel),
                                    );
                                  },
                                  childCount: viewModel.products.length,
                                ),
                              ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product, HomeViewModel viewModel) {
    viewModel.addToRecentlyViewed(product);
    // TODO: Navigate to product detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${product.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: Colors.grey[600],
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
