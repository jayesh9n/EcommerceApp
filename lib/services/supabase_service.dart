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

  // --- B2B HARDWARE CATEGORIES MATCHING REFERENCE IMAGES ---
  static const List<Category> _mockCategories = [
    Category(
      id: 'cat_1',
      name: 'Concrete Nails',
      imageUrl: 'https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=300',
      subCount: 1,
    ),
    Category(
      id: 'cat_2',
      name: 'Nylon Cable Ties',
      imageUrl: 'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=300',
      subCount: 2,
    ),
    Category(
      id: 'cat_3',
      name: 'Round Sheets',
      imageUrl: 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=300',
      subCount: 1,
    ),
    Category(
      id: 'cat_4',
      name: 'Cable Nail Clips',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      subCount: 3,
    ),
    Category(
      id: 'cat_5',
      name: 'UPVC/CPVC Clamps',
      imageUrl: 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=300',
      subCount: 3,
    ),
    Category(
      id: 'cat_6',
      name: 'Wallplugs (Gitti)',
      imageUrl: 'https://images.unsplash.com/photo-1618090584126-129cd1f3fbae?w=300',
      subCount: 3,
    ),
    Category(
      id: 'cat_7',
      name: 'Double Nail Clamps',
      imageUrl: 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=300',
      subCount: 3,
    ),
    Category(
      id: 'cat_8',
      name: 'Insulation Tapes',
      imageUrl: 'https://images.unsplash.com/photo-1618090584126-129cd1f3fbae?w=300',
      subCount: 3,
    ),
    Category(
      id: 'cat_9',
      name: 'MCB Boxes',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      subCount: 1,
    ),
    Category(
      id: 'cat_10',
      name: 'Modular Surface Gang Box',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      subCount: 1,
    ),
    Category(
      id: 'cat_11',
      name: 'Open Surface Gang Box',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      subCount: 1,
    ),
    Category(
      id: 'cat_12',
      name: 'Push Button Distribution Box',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      subCount: 1,
    ),
  ];

  // --- B2B HARDWARE PRODUCTS MATCHING REFERENCE IMAGES ---
  static const List<Product> _mockProducts = [
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
      stock: 0, // Out of Stock in Reference Image
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
      id: 'prod_8mm',
      title: 'HI-TECH 8MM CABLE CLIP-100PCS( 750PKT)',
      categoryId: 'cat_4',
      mrp: 10875.0,
      sellingPrice: 5437.50,
      unitLabel: '1box',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      stock: 100,
    ),
    Product(
      id: 'prod_9mm',
      title: 'HI-TECH 9MM CABLE CLIP-100PCS( 750PKT)',
      categoryId: 'cat_4',
      mrp: 11000.0,
      sellingPrice: 5500.00,
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
    Product(
      id: 'prod_4m_box',
      title: 'HI-TECH 4M OPEN SURFACE GANG BOX',
      categoryId: 'cat_11',
      mrp: 20448.0,
      sellingPrice: 10224.00,
      unitLabel: '1box',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      stock: 100,
    ),
    Product(
      id: 'prod_6m_box',
      title: 'HI-TECH 6M OPEN SURFACE GANG BOX',
      categoryId: 'cat_11',
      mrp: 17792.0,
      sellingPrice: 8896.00,
      unitLabel: '1box',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      stock: 100,
    ),
    Product(
      id: 'prod_32mm_dbl',
      title: 'HI-TECH 32MMDBL-500PCS',
      categoryId: 'cat_7',
      mrp: 8464.0,
      sellingPrice: 4232.00,
      unitLabel: '1box',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300',
      stock: 100,
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
