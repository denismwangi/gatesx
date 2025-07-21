import 'package:flutter/material.dart';

class PromotionalSlider extends StatefulWidget {
  const PromotionalSlider({super.key});

  @override
  State<PromotionalSlider> createState() => _PromotionalSliderState();
}

class _PromotionalSliderState extends State<PromotionalSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<PromotionalItem> _promotions = [
    PromotionalItem(
      title: 'Exclusive 50%',
      subtitle: 'Luxury Sale',
      buttonText: 'Shop Now',
      backgroundColor: const Color(0xFF8B7CF6),
      imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400&h=300&fit=crop',
    ),
    PromotionalItem(
      title: 'Summer Collection',
      subtitle: 'New Arrivals',
      buttonText: 'Explore',
      backgroundColor: const Color(0xFF10B981),
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=300&fit=crop',
    ),
    PromotionalItem(
      title: 'Weekend Special',
      subtitle: 'Up to 70% Off',
      buttonText: 'Shop Now',
      backgroundColor: const Color(0xFFF59E0B),
      imageUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=400&h=300&fit=crop',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 180,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _promotions.length,
            itemBuilder: (context, index) {
              return _buildPromotionalCard(_promotions[index]);
            },
          ),
          
          // Page Indicators
          Positioned(
            bottom: 16,
            left: 16,
            child: Row(
              children: List.generate(
                _promotions.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalCard(PromotionalItem item) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            item.backgroundColor,
            item.backgroundColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Image
          Positioned(
            right: -20,
            top: -20,
            bottom: -20,
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(item.imageUrl),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Opulent Savings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PromotionalItem {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color backgroundColor;
  final String imageUrl;

  PromotionalItem({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.backgroundColor,
    required this.imageUrl,
  });
}
