import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class SupabaseService {
  final SupabaseClient? _client;

  SupabaseService({SupabaseClient? client}) : _client = client;

  SupabaseClient get _safeClient {
    try {
      return _client ?? Supabase.instance.client;
    } catch (_) {
      throw Exception('Supabase client not initialized');
    }
  }

  // --- B2B HARDWARE MOCK DATA ---
  static const List<Category> _mockCategories = [
    Category(
      id: 'cat_1',
      name: 'Concrete Nails',
      imageUrl: 'https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=300',
      subCount: 3,
    ),
    Category(
      id: 'cat_2',
      name: 'Nylon Cable Ties',
      imageUrl: 'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=300',
      subCount: 4,
    ),
    Category(
      id: 'cat_3',
      name: 'Round Sheets',
      imageUrl: 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=300',
      subCount: 2,
    ),
    Category(
      id: 'cat_4',
      name: 'Cable Nail Clips',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      subCount: 5,
    ),
    Category(
      id: 'cat_5',
      name: 'UPVC/CPVC Clamps',
      imageUrl: 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=300',
      subCount: 3,
    ),
    Category(
      id: 'cat_6',
      name: 'Insulation Tapes',
      imageUrl: 'https://images.unsplash.com/photo-1618090584126-129cd1f3fbae?w=300',
      subCount: 1,
    ),
  ];

  static const List<Product> _mockProducts = [
    Product(
      id: 'prod_1',
      title: 'Galvanized Steel Concrete Nails 2.5 Inch',
      categoryId: 'cat_1',
      mrp: 1200.0,
      sellingPrice: 850.0,
      unitLabel: '1 Box (1000 Pcs)',
      imageUrl: 'https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=300',
      stock: 500,
    ),
    Product(
      id: 'prod_2',
      title: 'Heavy Duty Nylon Cable Ties 300mm Black',
      categoryId: 'cat_2',
      mrp: 450.0,
      sellingPrice: 299.0,
      unitLabel: ' Pack of 100',
      imageUrl: 'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=300',
      stock: 1200,
    ),
    Product(
      id: 'prod_3',
      title: 'Brass Round Washer Sheet Discs 2mm',
      categoryId: 'cat_3',
      mrp: 3500.0,
      sellingPrice: 2800.0,
      unitLabel: '5 Kg Pack',
      imageUrl: 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=300',
      stock: 45,
    ),
    Product(
      id: 'prod_4',
      title: 'Square Cable Nail Clips 6mm White',
      categoryId: 'cat_4',
      mrp: 300.0,
      sellingPrice: 180.0,
      unitLabel: '100 Pcs',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      stock: 800,
    ),
  ];

  Future<List<Category>> getCategories() async {
    try {
      final response = await _safeClient.from('categories').select();
      final data = response as List<dynamic>;
      if (data.isEmpty) return _mockCategories;
      return data.map((json) => Category.fromJson(json as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockCategories;
    }
  }

  Future<List<Product>> getProducts({String? categoryId, String? searchQuery}) async {
    try {
      var query = _safeClient.from('products').select();
      if (categoryId != null && categoryId.isNotEmpty) {
        query = query.eq('categoryId', categoryId);
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.ilike('title', '%${searchQuery.trim()}%');
      }
      final response = await query;
      final data = response as List<dynamic>;
      if (data.isEmpty) return _filterMockProducts(categoryId: categoryId, searchQuery: searchQuery);
      return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    } catch (_) {
      return _filterMockProducts(categoryId: categoryId, searchQuery: searchQuery);
    }
  }

  List<Product> _filterMockProducts({String? categoryId, String? searchQuery}) {
    return _mockProducts.where((p) {
      final matchCat = categoryId == null || categoryId.isEmpty || p.categoryId == categoryId;
      final matchQuery = searchQuery == null ||
          searchQuery.trim().isEmpty ||
          p.title.toLowerCase().contains(searchQuery.trim().toLowerCase());
      return matchCat && matchQuery;
    }).toList();
  }

  Future<Map<String, dynamic>> createOrder({
    required String userId,
    required List<CartItem> items,
    required double totalAmount,
    String? paymentId,
  }) async {
    try {
      final orderData = {
        'user_id': userId,
        'total_amount': totalAmount,
        'payment_id': paymentId,
        'status': 'pending',
        'items': items.map((item) => item.toJson()).toList(),
        'created_at': DateTime.now().toIso8601String(),
      };
      final response = await _safeClient.from('orders').insert(orderData).select().single();
      return response as Map<String, dynamic>;
    } catch (_) {
      return {
        'id': 'order_${DateTime.now().millisecondsSinceEpoch}',
        'user_id': userId,
        'total_amount': totalAmount,
        'payment_id': paymentId ?? 'mock_payment_id',
        'status': 'success',
      };
    }
  }
}
