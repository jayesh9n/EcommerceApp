import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import 'order_success_screen.dart';
import 'select_payment_method_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  String _paymentMethod = 'Bank Transfer';
  bool _showCoupons = true;

  @override
  void dispose() {
    _couponController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    final cartItems = ref.read(cartProvider);
    final totalAmount = ref.read(cartTotalPriceProvider);

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty!')),
      );
      return;
    }

    // Clear cart & Navigate to OrderSuccessScreen matching reference
    ref.read(cartProvider.notifier).clearCart();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          orderId: '${1000 + DateTime.now().millisecond}',
          amount: totalAmount,
          paymentMethod: _paymentMethod == 'Bank Transfer' ? 'BT' : 'ONLINE',
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    Widget? trailingAction,
    Widget? content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 6, color: CheckoutScreen.primaryGreen),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                if (subtitle != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    subtitle,
                                    style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (trailingAction != null) trailingAction,
                        ],
                      ),
                      if (content != null) ...[
                        const SizedBox(height: 12),
                        content,
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Delivery Section
            _buildSectionCard(
              title: 'Delivery',
              subtitle: 'Shipping / Home delivery',
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.map, color: CheckoutScreen.primaryGreen, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 2),
                        Text('Jayesh, +91 8160966370', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        SizedBox(height: 2),
                        Text(
                          '2HFC+2G3, Narolgam, Narolgam, Ahmedabad, Gujarat, India - 380006',
                          style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Additional Instructions
            _buildSectionCard(
              title: 'Additional Instructions',
              subtitle: 'Add your instructions or notes (optional)',
              trailingAction: TextButton(
                onPressed: () {},
                child: const Text('Add', style: TextStyle(color: CheckoutScreen.primaryGreen, fontWeight: FontWeight.bold)),
              ),
            ),

            // Upload Attachments
            _buildSectionCard(
              title: 'Upload Attachments',
              subtitle: 'Upload attachments or files (optional)',
              trailingAction: TextButton(
                onPressed: () {},
                child: const Text('Upload', style: TextStyle(color: CheckoutScreen.primaryGreen, fontWeight: FontWeight.bold)),
              ),
            ),

            // Use Coupons
            _buildSectionCard(
              title: 'Use Coupons',
              subtitle: 'Apply a coupon code',
              trailingAction: TextButton(
                onPressed: () => setState(() => _showCoupons = !_showCoupons),
                child: Row(
                  children: [
                    const Text('View Coupons', style: TextStyle(color: CheckoutScreen.primaryGreen, fontWeight: FontWeight.bold)),
                    Icon(_showCoupons ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: CheckoutScreen.primaryGreen, size: 18),
                  ],
                ),
              ),
              content: _showCoupons
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _couponController,
                            decoration: InputDecoration(
                              hintText: 'Enter here...',
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Coupon Applied!'), backgroundColor: CheckoutScreen.primaryGreen),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CheckoutScreen.primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  : null,
            ),

            // Payment Method & Place Order Bottom Controls
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Payment Method', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                          const SizedBox(height: 2),
                          GestureDetector(
                            onTap: () async {
                              final selected = await Navigator.push<String>(
                                context,
                                MaterialPageRoute(builder: (context) => const SelectPaymentMethodScreen()),
                              );
                              if (selected != null) {
                                setState(() => _paymentMethod = selected);
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  _paymentMethod,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF111827)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: cartItems.isEmpty ? null : _placeOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CheckoutScreen.primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Place Order',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
