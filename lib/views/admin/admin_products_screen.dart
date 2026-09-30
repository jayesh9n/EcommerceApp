import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../controllers/admin_providers.dart';
import '../../models/models.dart';

class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  ConsumerState<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditProductModal([Product? product]) {
    final isEdit = product != null;
    final titleController = TextEditingController(text: isEdit ? product.title : '');
    final mrpController = TextEditingController(text: isEdit ? product.mrp.toString() : '');
    final priceController = TextEditingController(text: isEdit ? product.sellingPrice.toString() : '');
    final unitController = TextEditingController(text: isEdit ? product.unitLabel : '1box');
    final stockController = TextEditingController(text: isEdit ? product.stock.toString() : '100');
    final imageController = TextEditingController(text: isEdit ? product.imageUrl : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isEdit ? 'Edit Product' : 'Add New Hardware Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Product Title', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: mrpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'MRP (₹)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Selling Price (₹)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: unitController,
                      decoration: const InputDecoration(labelText: 'Unit Label (e.g. 1box)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Stock Quantity', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL (optional)', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) return;
              final newProduct = Product(
                id: isEdit ? product.id : 'prod_${DateTime.now().millisecondsSinceEpoch}',
                title: titleController.text.trim(),
                categoryId: 'cat_4',
                mrp: double.tryParse(mrpController.text) ?? 1000.0,
                sellingPrice: double.tryParse(priceController.text) ?? 500.0,
                unitLabel: unitController.text.trim(),
                imageUrl: imageController.text.trim(),
                stock: int.tryParse(stockController.text) ?? 100,
              );

              if (isEdit) {
                ref.read(adminProductsProvider.notifier).updateProduct(newProduct);
              } else {
                ref.read(adminProductsProvider.notifier).addProduct(newProduct);
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isEdit ? 'Product updated!' : 'Product added successfully!'),
                  backgroundColor: AdminProductsScreen.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminProductsScreen.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: Text(isEdit ? 'Update Product' : 'Add Product'),
          ),
        ],
      ),
    );
  }

  void _showAdjustStockDialog(Product product) {
    final stockController = TextEditingController(text: product.stock.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adjust Stock: ${product.title}'),
        content: TextField(
          controller: stockController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'New Stock Level', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(stockController.text) ?? 0;
              ref.read(adminProductsProvider.notifier).updateStock(product.id, newStock);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Stock level updated!'), backgroundColor: AdminProductsScreen.primaryGreen),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AdminProductsScreen.primaryGreen, foregroundColor: Colors.white),
            child: const Text('Save Stock'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(adminProductsProvider);

    final filteredProducts = products.where((p) {
      return p.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Products Management',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Add, edit, adjust stock, or remove hardware inventory',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditProductModal(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminProductsScreen.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add New Product', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: const InputDecoration(
                hintText: 'Search products by title...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Products Table
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
                dataRowHeight: 70,
                columns: const [
                  DataColumn(label: Text('Product', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('MRP', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Selling Price', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Unit Label', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Stock Status', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: filteredProducts.map((product) {
                  final isOut = product.stock <= 0;
                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D4ED8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.hardware, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                product.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(_currencyFormat.format(product.mrp))),
                      DataCell(
                        Text(
                          _currencyFormat.format(product.sellingPrice),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AdminProductsScreen.primaryGreen),
                        ),
                      ),
                      DataCell(Text(product.unitLabel)),
                      DataCell(
                        GestureDetector(
                          onTap: () => _showAdjustStockDialog(product),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isOut ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isOut ? Colors.red : AdminProductsScreen.primaryGreen),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${product.stock} units',
                                  style: TextStyle(
                                    color: isOut ? Colors.red : const Color(0xFF047857),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.edit_outlined, size: 14, color: isOut ? Colors.red : const Color(0xFF047857)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Color(0xFF3B82F6), size: 20),
                              onPressed: () => _showAddEditProductModal(product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              onPressed: () {
                                ref.read(adminProductsProvider.notifier).deleteProduct(product.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Product deleted!')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
