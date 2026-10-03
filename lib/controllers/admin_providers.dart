import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/supabase_service.dart';
import 'providers.dart';

class AdminProductNotifier extends StateNotifier<List<Product>> {
  final SupabaseService _service;

  AdminProductNotifier(this._service) : super(const []) {
    _loadFromSupabase();
  }

  Future<void> _loadFromSupabase() async {
    try {
      final products = await _service.getProducts();
      if (products.isNotEmpty) {
        state = products;
      }
    } catch (_) {}
  }

  Future<void> addProduct(Product product) async {
    state = [product, ...state];
    await _service.addProduct(product);
  }

  Future<void> bulkAddProducts(List<Product> products) async {
    state = [...products, ...state];
    for (final product in products) {
      await _service.addProduct(product);
    }
  }

  Future<void> updateProduct(Product updated) async {
    state = [
      for (final p in state)
        if (p.id == updated.id) updated else p
    ];
    await _service.updateProduct(updated);
  }

  Future<void> deleteProduct(String id) async {
    state = state.where((p) => p.id != id).toList();
    await _service.deleteProduct(id);
  }

  Future<void> updateStock(String id, int stock) async {
    state = [
      for (final p in state)
        if (p.id == id)
          Product(
            id: p.id,
            title: p.title,
            categoryId: p.categoryId,
            mrp: p.mrp,
            sellingPrice: p.sellingPrice,
            unitLabel: p.unitLabel,
            imageUrl: p.imageUrl,
            stock: stock,
          )
        else
          p
    ];
    await _service.updateStock(id, stock);
  }
}

final adminProductsProvider =
    StateNotifierProvider<AdminProductNotifier, List<Product>>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  return AdminProductNotifier(service);
});

class AdminCategoryNotifier extends StateNotifier<List<Category>> {
  final SupabaseService _service;

  AdminCategoryNotifier(this._service) : super(const []) {
    _loadFromSupabase();
  }

  Future<void> _loadFromSupabase() async {
    try {
      final categories = await _service.getCategories();
      if (categories.isNotEmpty) {
        state = categories;
      }
    } catch (_) {}
  }

  Future<void> addCategory(Category category) async {
    state = [...state, category];
    await _service.addCategory(category);
  }

  Future<void> deleteCategory(String id) async {
    state = state.where((c) => c.id != id).toList();
    await _service.deleteCategory(id);
  }
}

final adminCategoriesProvider =
    StateNotifierProvider<AdminCategoryNotifier, List<Category>>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  return AdminCategoryNotifier(service);
});

class AdminOrderModel {
  final String id;
  final String customerName;
  final String phone;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final DateTime date;
  final int itemsCount;

  const AdminOrderModel({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.date,
    required this.itemsCount,
  });
}

class AdminOrderNotifier extends StateNotifier<List<AdminOrderModel>> {
  AdminOrderNotifier() : super(const []);

  void updateOrderStatus(String orderId, String newStatus) {
    state = [
      for (final o in state)
        if (o.id == orderId)
          AdminOrderModel(
            id: o.id,
            customerName: o.customerName,
            phone: o.phone,
            totalAmount: o.totalAmount,
            paymentMethod: o.paymentMethod,
            status: newStatus,
            date: o.date,
            itemsCount: o.itemsCount,
          )
        else
          o
    ];
  }
}

final adminOrdersProvider =
    StateNotifierProvider<AdminOrderNotifier, List<AdminOrderModel>>((ref) {
  return AdminOrderNotifier();
});
