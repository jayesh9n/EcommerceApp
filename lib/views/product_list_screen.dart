import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/providers.dart';
import '../models/models.dart';
import 'cart_screen.dart';
import 'product_details_screen.dart';
import 'admin/admin_shell_view.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryTitle;

  const ProductListScreen({
    super.key,
    this.categoryId = '',
    this.categoryTitle = 'Hardware Products',
  });

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalCount = ref.watch(cartTotalCountProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);
    final wishlistedProducts = ref.watch(wishlistProvider);

    final allProducts = ref.watch(productsProvider);
    final categories = ref.watch(categoriesProvider);

    // Filter products category-wise
    final categoryProducts = allProducts.where((p) {
      if (widget.categoryId.isNotEmpty) {
        return p.categoryId == widget.categoryId;
      }
      if (widget.categoryTitle.isNotEmpty) {
        final cat = categories.firstWhere(
          (c) => c.name.toLowerCase() == widget.categoryTitle.toLowerCase(),
          orElse: () => const Category(id: '', name: '', imageUrl: '', subCount: 0),
        );
        if (cat.id.isNotEmpty) return p.categoryId == cat.id;
      }
      return true;
    }).where((p) {
      if (_searchQuery.trim().isEmpty) return true;
      return p.title.toLowerCase().contains(_searchQuery.trim().toLowerCase());
    }).toList();

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
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Left Sidebar (Categories list for quick switching)
                if (categories.isNotEmpty)
                  Container(
                    width: 90,
                    color: const Color(0xFFFAFAFA),
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = cat.id == widget.categoryId ||
                            cat.name.toLowerCase() == widget.categoryTitle.toLowerCase();
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductListScreen(
                                  categoryId: cat.id,
                                  categoryTitle: cat.name,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                            child: Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF1D4ED8),
                                    border: Border.all(
                                      color: isSelected ? ProductListScreen.primaryGreen : Colors.transparent,
                                      width: 2.5,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.hardware, color: Colors.white, size: 22),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  cat.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
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
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => setState(() => _searchQuery = val),
                            decoration: const InputDecoration(
                              hintText: 'Search products in category...',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),

                      // 2-Column Grid or Empty State
                      if (categoryProducts.isEmpty)
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.inventory_2_outlined, size: 56, color: Color(0xFF9CA3AF)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No products in "${widget.categoryTitle}"',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF111827)),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Add products under this category from the Admin Portal.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const AdminShellView()),
                                      );
                                    },
                                    icon: const Icon(Icons.shield_outlined, size: 16),
                                    label: const Text('Open Admin Portal', style: TextStyle(fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ProductListScreen.primaryGreen,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.62,
                            ),
                            itemCount: categoryProducts.length,
                            itemBuilder: (context, index) {
                              final product = categoryProducts[index];
                              final cartIndex = cartItems.indexWhere((ci) => ci.product.id == product.id);
                              final qty = cartIndex >= 0 ? cartItems[cartIndex].quantity : 0;
                              final isOutOfStock = product.stock <= 0;
                              final isWishlisted = wishlistedProducts.any((p) => p.id == product.id);

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
                                               child: GestureDetector(
                                                 onTap: () {
                                                   ref.read(wishlistProvider.notifier).toggleWishlist(product);
                                                   final isAdded = ref.read(wishlistProvider.notifier).isWishlisted(product.id);
                                                   ScaffoldMessenger.of(context).showSnackBar(
                                                     SnackBar(
                                                       content: Text(isAdded ? 'Added to wishlist' : 'Removed from wishlist'),
                                                       duration: const Duration(seconds: 1),
                                                     ),
                                                   );
                                                 },
                                                 child: Container(
                                                   padding: const EdgeInsets.all(3),
                                                   decoration: const BoxDecoration(
                                                     color: Colors.white,
                                                     shape: BoxShape.circle,
                                                   ),
                                                   child: Icon(
                                                     isWishlisted ? Icons.favorite : Icons.favorite_border,
                                                     color: isWishlisted ? Colors.red : ProductListScreen.primaryGreen,
                                                     size: 14,
                                                   ),
                                                 ),
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
