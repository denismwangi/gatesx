import 'package:flutter/material.dart';

class CartTotalsWidget extends StatefulWidget {
  final double subtotal;
  final double discountedTotal;
  final double totalDiscount;
  final VoidCallback? onCheckout;

  const CartTotalsWidget({
    Key? key,
    required this.subtotal,
    required this.discountedTotal,
    required this.totalDiscount,
    this.onCheckout,
  }) : super(key: key);

  @override
  State<CartTotalsWidget> createState() => _CartTotalsWidgetState();
}

class _CartTotalsWidgetState extends State<CartTotalsWidget> {
  final TextEditingController _discountController = TextEditingController();
  double _additionalDiscount = 0.0;

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void _applyDiscount() {
    // This is a mock implementation - you can implement actual discount logic
    final discountCode = _discountController.text.trim();
    if (discountCode.isNotEmpty) {
      setState(() {
        _additionalDiscount = widget.subtotal * 0.1; // 10% discount
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Discount applied successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  double get finalTotal => widget.discountedTotal - _additionalDiscount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Discount Code Section
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _discountController,
                  decoration: InputDecoration(
                    hintText: 'Enter Discount Code',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.orange[600]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _applyDiscount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Totals Section
          Column(
            children: [
              // Subtotal
              _buildTotalRow(
                'Subtotal',
                '\$${widget.subtotal.toStringAsFixed(2)}',
                isSubtotal: true,
              ),
              
              // Original Discount (if any)
              if (widget.totalDiscount > 0)
                _buildTotalRow(
                  'Discount',
                  '-\$${widget.totalDiscount.toStringAsFixed(2)}',
                  isDiscount: true,
                ),
              
              // Additional Discount (if any)
              if (_additionalDiscount > 0)
                _buildTotalRow(
                  'Promo Discount',
                  '-\$${_additionalDiscount.toStringAsFixed(2)}',
                  isDiscount: true,
                ),
              
              const Divider(height: 20),
              
              // Total
              _buildTotalRow(
                'Total',
                '\$${finalTotal.toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    String amount, {
    bool isSubtotal = false,
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.black54,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isDiscount
                  ? Colors.green[600]
                  : isTotal
                      ? Colors.black87
                      : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
