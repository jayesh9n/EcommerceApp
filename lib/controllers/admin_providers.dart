import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

class AdminProductNotifier extends StateNotifier<List<Product>> {
  AdminProductNotifier()
      : super(const [
          Product(
            id: 'prod_4mm',
            title: 'HI-TECH 4MM CABLE CLIP-100PCS( 750PKT)',
            categoryId: 'cat_4',
            mrp: 10875.0,
            sellingPrice: 5437.50,
            unitLabel: '1box',
            imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
            stock: 100,
          ),
          Product(
            id: 'prod_5mm',
            title: 'HI-TECH 5MM CABLE CLIP-100PCS( 750PKT)',
            categoryId: 'cat_4',
            mrp: 8855.0,
            sellingPrice: 4427.50,
            unitLabel: '1box',
            imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
            stock: 100,
          ),
          Product(
            id: 'prod_6mm',
            title: 'HI-TECH 6MM CABLE CLIP-100PCS( 750PKT)',
            categoryId: 'cat_4',
            mrp: 8370.0,
            sellingPrice: 4185.00,
            unitLabel: '1box',
            imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
            stock: 0,
          ),
          Product(
            id: 'prod_7mm',
            title: 'HI-TECH 7MM CABLE CLIP-100PCS( 750PKT)',
            categoryId: 'cat_4',
            mrp: 9120.0,
            sellingPrice: 4560.00,
            unitLabel: '1box',
            imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
            stock: 100,
          ),
          Product(
            id: 'prod_2m_box',
            title: 'HI-TECH 2M OPEN SURFACE GANG BOX',
            categoryId: 'cat_11',
            mrp: 20864.0,
            sellingPrice: 10432.00,
            unitLabel: '1box',
            imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
            stock: 100,
          ),
          Product(
            id: 'prod_3m_box',
            title: 'HI-TECH 3M OPEN SURFACE GANG BOX',
            categoryId: 'cat_11',
            mrp: 22288.0,
            sellingPrice: 11144.00,
            unitLabel: '1box',
            imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
            stock: 100,
          ),
        ]);

  void addProduct(Product product) {
    state = [product, ...state];
  }

  void updateProduct(Product updated) {
    state = [
      for (final p in state)
        if (p.id == updated.id) updated else p
    ];
  }

  void deleteProduct(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  void updateStock(String id, int stock) {
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
  }
}

final adminProductsProvider =
    StateNotifierProvider<AdminProductNotifier, List<Product>>((ref) {
  return AdminProductNotifier();
});

class AdminCategoryNotifier extends StateNotifier<List<Category>> {
  AdminCategoryNotifier()
      : super(const [
          Category(id: 'cat_1', name: 'Concrete Nails', imageUrl: '', subCount: 1),
          Category(id: 'cat_2', name: 'Nylon Cable Ties', imageUrl: '', subCount: 2),
          Category(id: 'cat_3', name: 'Round Sheets', imageUrl: '', subCount: 1),
          Category(id: 'cat_4', name: 'Cable Nail Clips', imageUrl: '', subCount: 3),
          Category(id: 'cat_5', name: 'UPVC/CPVC Clamps', imageUrl: '', subCount: 3),
          Category(id: 'cat_6', name: 'Wallplugs (Gitti)', imageUrl: '', subCount: 3),
          Category(id: 'cat_7', name: 'Double Nail Clamps', imageUrl: '', subCount: 3),
          Category(id: 'cat_8', name: 'Insulation Tapes', imageUrl: '', subCount: 3),
          Category(id: 'cat_9', name: 'MCB Boxes', imageUrl: '', subCount: 1),
          Category(id: 'cat_10', name: 'Modular Surface Gang Box', imageUrl: '', subCount: 1),
          Category(id: 'cat_11', name: 'Open Surface Gang Box', imageUrl: '', subCount: 1),
          Category(id: 'cat_12', name: 'Push Button Distribution Box', imageUrl: '', subCount: 1),
        ]);

  void addCategory(Category category) {
    state = [...state, category];
  }

  void deleteCategory(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

final adminCategoriesProvider =
    StateNotifierProvider<AdminCategoryNotifier, List<Category>>((ref) {
  return AdminCategoryNotifier();
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
  AdminOrderNotifier()
      : super([
          AdminOrderModel(
            id: 'ORD-5989',
            customerName: 'Jayesh Patel',
            phone: '+91 8160966370',
            totalAmount: 16634.46,
            paymentMethod: 'Bank Transfer',
            status: 'Delivered',
            date: DateTime.now().subtract(const Duration(hours: 4)),
            itemsCount: 3,
          ),
          AdminOrderModel(
            id: 'ORD-5988',
            customerName: 'Ramesh Hardware & Tools',
            phone: '+91 9876543210',
            totalAmount: 42320.00,
            paymentMethod: 'Bank Transfer',
            status: 'Shipped',
            date: DateTime.now().subtract(const Duration(days: 1)),
            itemsCount: 8,
          ),
          AdminOrderModel(
            id: 'ORD-5987',
            customerName: 'Anil Electricals',
            phone: '+91 9123456789',
            totalAmount: 10432.00,
            paymentMethod: 'Online Razorpay',
            status: 'Pending',
            date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
            itemsCount: 2,
          ),
          AdminOrderModel(
            id: 'ORD-5986',
            customerName: 'Gujarat Enterprise',
            phone: '+91 9988776655',
            totalAmount: 28500.00,
            paymentMethod: 'Bank Transfer',
            status: 'Processing',
            date: DateTime.now().subtract(const Duration(days: 2)),
            itemsCount: 5,
          ),
        ]);

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
