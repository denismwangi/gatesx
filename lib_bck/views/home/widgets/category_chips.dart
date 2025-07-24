import 'package:flutter/material.dart';
import '../../../models/category.dart';

class CategoryChips extends StatefulWidget {
  final List<Category> categories;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categories.length + 1, // +1 for "All" chip
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" chip
            return _buildCategoryChip(
              'All',
              'all',
              _selectedCategory == null || _selectedCategory == 'all',
            );
          }
          
          final category = widget.categories[index - 1];
          return _buildCategoryChip(
            category.displayName,
            category.slug,
            _selectedCategory == category.slug,
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (value == 'all') {
              _selectedCategory = null;
              // Fetch all products
              widget.onCategorySelected('');
            } else {
              _selectedCategory = value;
              widget.onCategorySelected(value);
            }
          });
        },
        backgroundColor: Colors.grey[100],
        selectedColor: const Color(0xFF6366F1),
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
