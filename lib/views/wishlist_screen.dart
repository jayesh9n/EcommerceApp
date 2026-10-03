import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/providers.dart';
import 'widgets/empty_state_widget.dart';
import 'product_details_screen.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);
    final cartItems = ref.watch(cartProvider);
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Wishlist (${wishlist.length})',
          style: const TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          if (wishlist.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(wishlistProvider.notifier).clearWishlist();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wishlist cleared'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: wishlist.isEmpty
          ? const EmptyStateWidget(
              title: 'Oh, no!',
              message: 'There are no items in the wishlist.',
              subMessage: 'To add items to wishlist, click on the heart icon.',
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final product = wishlist[index];
                final cartItemIndex = cartItems.indexWhere((item) => item.product.id == product.id);
                final qty = cartItemIndex >= 0 ? cartItems[cartItemIndex].quantity : 0;
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
                        // Image / Blue Card Container
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
                              // Remove from Wishlist Heart Button
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    ref.read(wishlistProvider.notifier).removeFromWishlist(product.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Removed from wishlist'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x1F000000),
                                          blurRadius: 4,
                                        )
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                              // Add to Cart Button
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
                                          child: const Text('Out of stock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.red)),
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
                                              icon: const Icon(Icons.add, color: primaryGreen, size: 16),
                                              label: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                            )
                                          : Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: primaryGreen,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 4)],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      ref.read(cartProvider.notifier).updateQuantity(product.id, qty - 1);
                                                    },
                                                    child: const Icon(Icons.remove, color: Colors.white, size: 16),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    child: Text(
                                                      '$qty',
                                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      ref.read(cartProvider.notifier).addItem(product);
                                                    },
                                                    child: const Icon(Icons.add, color: Colors.white, size: 16),
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
                        // Product Text Details
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF111827)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                          child: Text(
                            product.unitLabel,
                            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 10),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                          child: Row(
                            children: [
                              Text(
                                currencyFormat.format(product.sellingPrice),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF111827)),
                              ),
                              const SizedBox(width: 4),
                              if (product.mrp > product.sellingPrice)
                                Text(
                                  currencyFormat.format(product.mrp),
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 10,
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
    );
  }
}

