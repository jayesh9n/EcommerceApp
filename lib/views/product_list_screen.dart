import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/providers.dart';
import '../models/models.dart';
import 'cart_screen.dart';
import 'product_details_screen.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  final String categoryTitle;

  const ProductListScreen({
    super.key,
    this.categoryTitle = 'Cable Nail Clips',
  });

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  int _selectedSidebarIndex = 0;
  final _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

  final List<Map<String, String>> _sidebarItems = const [
    {'title': 'Hi-Tech Cable Nail ...', 'tag': 'hitech'},
    {'title': 'Tejas Cable Nail Clips', 'tag': 'tejas'},
    {'title': 'Other Cable Nail Clips', 'tag': 'other'},
  ];

  final List<Product> _mockListProducts = const [
    Product(
      id: 'prod_4mm',
      title: 'HI-TECH 4MM CABLE CLIP-100PCS( 750PKT)',
      categoryId: 'cat_4',
      mrp: 10875.0,
      sellingPrice: 5437.50,
      unitLabel: '1box',
      imageUrl: '',
      stock: 100,
    ),
    Product(
      id: 'prod_5mm',
      title: 'HI-TECH 5MM CABLE CLIP-100PCS( 750PKT)',
      categoryId: 'cat_4',
      mrp: 8855.0,
      sellingPrice: 4427.50,
      unitLabel: '1box',
      imageUrl: '',
      stock: 100,
    ),
    Product(
      id: 'prod_6mm',
      title: 'HI-TECH 6MM CABLE CLIP-100PCS( 750PKT)',
      categoryId: 'cat_4',
      mrp: 8370.0,
      sellingPrice: 4185.0,
      unitLabel: '1box',
      imageUrl: '',
      stock: 0, // Out of stock (Notify)
    ),
    Product(
      id: 'prod_7mm',
      title: 'HI-TECH 7MM CABLE CLIP-100PCS( 750PKT)',
      categoryId: 'cat_4',
      mrp: 9120.0,
      sellingPrice: 4560.0,
      unitLabel: '1box',
      imageUrl: '',
      stock: 100,
    ),
    Product(
      id: 'prod_8mm',
      title: 'HI-TECH 8MM CABLE CLIP-100PCS( 750PKT)',
      categoryId: 'cat_4',
      mrp: 10875.0,
      sellingPrice: 5437.50,
      unitLabel: '1box',
      imageUrl: '',
      stock: 100,
    ),
    Product(
      id: 'prod_9mm',
      title: 'HI-TECH 9MM CABLE CLIP-100PCS( 750PKT)',
      categoryId: 'cat_4',
      mrp: 11000.0,
      sellingPrice: 5500.0,
      unitLabel: '1box',
      imageUrl: '',
      stock: 100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalCount = ref.watch(cartTotalCountProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF111827)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF111827)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Left Sidebar (Subcategories)
                Container(
                  width: 90,
                  color: const Color(0xFFFAFAFA),
                  child: ListView.builder(
                    itemCount: _sidebarItems.length,
                    itemBuilder: (context, index) {
                      final item = _sidebarItems[index];
                      final isSelected = _selectedSidebarIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSidebarIndex = index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                          child: Column(
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF1D4ED8),
                                  border: Border.all(
                                    color: isSelected ? ProductListScreen.primaryGreen : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(Icons.inventory_2_outlined, color: Colors.white, size: 24),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['title']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? ProductListScreen.primaryGreen : const Color(0xFF6B7280),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Right Main Area: Search Bar + Product Grid
                Expanded(
                  child: Column(
                    children: [
                      // Top Search Field inside Product List
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),

                      // 2-Column Grid
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.62,
                          ),
                          itemCount: _mockListProducts.length,
                          itemBuilder: (context, index) {
                            final product = _mockListProducts[index];
                            final cartIndex = cartItems.indexWhere((ci) => ci.product.id == product.id);
                            final qty = cartIndex >= 0 ? cartItems[cartIndex].quantity : 0;
                            final isOutOfStock = product.stock <= 0;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(product: product),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Blue Product Container
                                    Expanded(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1D4ED8),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: Text(
                                                  product.title,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xFFFACC15),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Discount Badge
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: ProductListScreen.primaryGreen,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                '50% OFF',
                                                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          // Heart icon
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.favorite_border, color: ProductListScreen.primaryGreen, size: 14),
                                            ),
                                          ),

                                          // Bottom Button: Add / Qty / Notify
                                          Positioned(
                                            bottom: -6,
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child: isOutOfStock
                                                  ? Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 4)],
                                                      ),
                                                      child: const Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(Icons.notifications_outlined, color: ProductListScreen.primaryGreen, size: 14),
                                                          SizedBox(width: 4),
                                                          Text('Notify', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                                        ],
                                                      ),
                                                    )
                                                  : qty == 0
                                                      ? ElevatedButton.icon(
                                                          onPressed: () {
                                                            ref.read(cartProvider.notifier).addItem(product);
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.white,
                                                            foregroundColor: const Color(0xFF111827),
                                                            elevation: 2,
                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                          ),
                                                          icon: const Icon(Icons.add, color: ProductListScreen.primaryGreen, size: 16),
                                                          label: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                        )
                                                      : Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(20),
                                                            boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 4)],
                                                          ),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () => ref.read(cartProvider.notifier).updateQuantity(product.id, qty - 1),
                                                                child: const Icon(Icons.remove_circle, color: ProductListScreen.primaryGreen, size: 20),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                                                child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () => ref.read(cartProvider.notifier).updateQuantity(product.id, qty + 1),
                                                                child: const Icon(Icons.add_circle, color: ProductListScreen.primaryGreen, size: 20),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (isOutOfStock)
                                            const Text(
                                              'Out of Stock',
                                              style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          Text(
                                            product.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF111827)),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                _currencyFormat.format(product.sellingPrice),
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF111827)),
                                              ),
                                              Text(
                                                ' / ${product.unitLabel}',
                                                style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            _currencyFormat.format(product.mrp),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF9CA3AF),
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom View Cart Bar
          if (totalCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currencyFormat.format(totalPrice),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      Text(
                        '$totalCount Item • $totalCount quantity',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ProductListScreen.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('View Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
