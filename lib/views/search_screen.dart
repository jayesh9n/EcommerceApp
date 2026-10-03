import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/providers.dart';
import '../models/models.dart';
import 'product_details_screen.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchProductsProvider = FutureProvider<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final service = ref.watch(supabaseServiceProvider);
  return service.getProducts(searchQuery: query);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(searchProductsProvider);
    final wishlistedProducts = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (val) {
              ref.read(searchQueryProvider.notifier).state = val;
            },
            decoration: const InputDecoration(
              hintText: 'Search for items or products...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trending Items Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Trending items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Icon(Icons.chevron_right, color: Color(0xFF111827)),
              ],
            ),
            const SizedBox(height: 16),

            // Horizontal Product Carousel
            productsAsync.when(
              data: (products) {
                return SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
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
                          width: 160,
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Blue Product Tile Image Container
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
                                    // 50% OFF Badge
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: SearchScreen.primaryGreen,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          '50% OFF',
                                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    // Heart Icon
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
                                             color: isWishlisted ? Colors.red : SearchScreen.primaryGreen,
                                             size: 14,
                                           ),
                                         ),
                                       ),
                                     ),
                                    // + Add Button
                                    Positioned(
                                      bottom: -6,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: ElevatedButton.icon(
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
                                          icon: const Icon(Icons.add, color: SearchScreen.primaryGreen, size: 16),
                                          label: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: SearchScreen.primaryGreen)),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
      ),
    );
  }
}
