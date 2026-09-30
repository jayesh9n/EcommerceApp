import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/providers.dart';
import 'addresses_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  bool _addressSelected = false;

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalCount = ref.watch(cartTotalCountProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);

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
          'Cart',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Delivery Address Card
                        Container(
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
                                  Container(width: 6, color: CartScreen.primaryGreen),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: const [
                                              Text(
                                                'Delivery',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                '•  Shipping / Home delivery',
                                                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          if (!_addressSelected)
                                            SizedBox(
                                              width: double.infinity,
                                              height: 46,
                                              child: OutlinedButton.icon(
                                                onPressed: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AddressesScreen()),
                                                  );
                                                  setState(() => _addressSelected = true);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(color: CartScreen.primaryGreen, width: 1.5),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                icon: const Icon(Icons.map_outlined, color: CartScreen.primaryGreen, size: 20),
                                                label: const Text(
                                                  'Select Delivery Address',
                                                  style: TextStyle(color: CartScreen.primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                                                ),
                                              ),
                                            )
                                          else
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF3F4F6),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: const Icon(Icons.map, color: CartScreen.primaryGreen, size: 24),
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Green Saving Banner
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.percent, color: Color(0xFF047857), size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Yay! You\'re saving',
                                style: TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                              const Spacer(),
                              Text(
                                _currencyFormat.format(totalPrice * 0.5),
                                style: const TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Items Section Container
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2)),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(width: 4, height: 18, color: CartScreen.primaryGreen),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Items',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '$totalCount Items',
                                        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),

                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cartItems.length,
                                  separatorBuilder: (context, index) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final item = cartItems[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Product Blue Box Thumbnail
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1D4ED8),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Center(
                                              child: Icon(Icons.inventory_2_outlined, color: Colors.white, size: 28),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.product.title,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF111827)),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${_currencyFormat.format(item.product.sellingPrice)} / ${item.product.unitLabel}',
                                                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // - 1 + Quantity Controls
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity - 1);
                                                },
                                                child: const Icon(Icons.remove_circle, color: CartScreen.primaryGreen, size: 24),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity + 1);
                                                },
                                                child: const Icon(Icons.add_circle, color: CartScreen.primaryGreen, size: 24),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Checkout Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, -3)),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currencyFormat.format(totalPrice),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$totalCount Items • $totalCount quantities',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CartScreen.primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 28),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              'Checkout',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
