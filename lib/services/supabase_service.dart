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

  // --- CATEGORIES SUPABASE CRUD ---

  Future<List<Category>> getCategories() async {
    try {
      final response = await _safeClient.from('categories').select();
      final data = response as List<dynamic>;
      return data.map((json) => Category.fromJson(json as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await _safeClient.from('categories').insert(category.toJson());
    } catch (_) {}
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _safeClient.from('categories').delete().eq('id', id);
    } catch (_) {}
  }

  // --- PRODUCTS SUPABASE CRUD ---

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
      return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _safeClient.from('products').insert(product.toJson());
    } catch (_) {}
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _safeClient.from('products').update(product.toJson()).eq('id', product.id);
    } catch (_) {}
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _safeClient.from('products').delete().eq('id', id);
    } catch (_) {}
  }

  Future<void> updateStock(String id, int stock) async {
    try {
      await _safeClient.from('products').update({'stock': stock}).eq('id', id);
    } catch (_) {}
  }

  // --- ORDERS ---

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
