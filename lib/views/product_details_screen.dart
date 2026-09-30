import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/providers.dart';
import '../models/models.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartItemIndex = cartItems.indexWhere((item) => item.product.id == widget.product.id);
    final currentQty = cartItemIndex >= 0 ? cartItems[cartItemIndex].quantity : 0;
    final discountAmount = widget.product.mrp - widget.product.sellingPrice;

    return Scaffold(
      backgroundColor: const Color(0xFF1D4ED8), // Deep blue hero background
      body: SafeArea(
        child: Column(
          children: [
            // Top Nav Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.download, color: ProductDetailsScreen.primaryGreen),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: ProductDetailsScreen.primaryGreen),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            // Hero Image Area
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.title,
                                style: const TextStyle(
                                  color: Color(0xFFFACC15), // Yellow text
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  height: 1.2,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 140,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: widget.product.imageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: widget.product.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(color: Colors.white),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.inventory, color: Colors.white, size: 60),
                                )
                              : const Icon(Icons.inventory, color: Colors.white, size: 60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Content Sheet
            Expanded(
              flex: 6,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 36, 20, 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HI-TECH CABLE NAIL CLIPS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B7280),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Price Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '₹${widget.product.sellingPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '₹${widget.product.mrp.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFD1D5DB)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.product.unitLabel,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                                ),
                              ),
                            ],
                          ),
                          if (discountAmount > 0) ...[
                            const SizedBox(height: 4),
                            Text(
                              'SAVE ₹${discountAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: ProductDetailsScreen.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),

                          // Badges Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F9F0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.percent, color: ProductDetailsScreen.primaryGreen, size: 14),
                                    SizedBox(width: 4),
                                    Text(
                                      '50% OFF',
                                      style: TextStyle(
                                        color: ProductDetailsScreen.primaryGreen,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.star, color: ProductDetailsScreen.primaryGreen, size: 14),
                                    SizedBox(width: 4),
                                    Text(
                                      'Reviews',
                                      style: TextStyle(
                                        color: Color(0xFF374151),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Similar items section
                          const Text(
                            'Similar items',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 120,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1D4ED8),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${(index + 5)}MM Clip',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Floating Add / Quantity Selector Button at Center Top Edge
                  Positioned(
                    top: -22,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: currentQty == 0
                          ? ElevatedButton.icon(
                              onPressed: () {
                                ref.read(cartProvider.notifier).addItem(widget.product);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF111827),
                                elevation: 4,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              icon: const Icon(Icons.add, color: ProductDetailsScreen.primaryGreen, size: 20),
                              label: const Text(
                                'Add',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1F000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: ProductDetailsScreen.primaryGreen),
                                    onPressed: () {
                                      ref.read(cartProvider.notifier).updateQuantity(widget.product.id, currentQty - 1);
                                    },
                                  ),
                                  Text(
                                    '$currentQty',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle, color: ProductDetailsScreen.primaryGreen),
                                    onPressed: () {
                                      ref.read(cartProvider.notifier).updateQuantity(widget.product.id, currentQty + 1);
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ),
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
