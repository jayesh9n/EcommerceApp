import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import '../services/supabase_service.dart';

// --- SERVICE PROVIDERS ---

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final service = ref.watch(supabaseServiceProvider);
  return service.getCategories();
});

// --- CART STATE MANAGEMENT ---

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Product product, [int quantity = 1]) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final existingItem = state[index];
      final updatedList = [...state];
      updatedList[index] = CartItem(
        product: product,
        quantity: existingItem.quantity + quantity,
      );
      state = updatedList;
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    state = [
      for (final item in state)
        if (item.product.id == productId)
          CartItem(product: item.product, quantity: quantity)
        else
          item,
    ];
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalPriceProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, item) => sum + (item.product.sellingPrice * item.quantity));
});

final cartTotalCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, item) => sum + item.quantity);
});

// --- AUTH STATE MANAGEMENT ---

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null) {
    try {
      final client = Supabase.instance.client;
      // Restore session on app start
      state = client.auth.currentSession?.user ?? client.auth.currentUser;
      client.auth.onAuthStateChange.listen((data) {
        state = data.session?.user;
      });
    } catch (_) {
      // Supabase not initialized — state remains null
    }
  }

  // ── Phone OTP ─────────────────────────────────────────────────────────────

  /// Step 1 — Request OTP. Call with full phone like '+919876543210'.
  Future<void> sendOtp(String phone) async {
    await Supabase.instance.client.auth.signInWithOtp(phone: phone);
  }

  /// Step 2 — Verify OTP. On success: sets state, upserts profile.
  Future<void> verifyOtp(String phone, String token) async {
    final res = await Supabase.instance.client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
    state = res.user;
    if (res.user != null) await _upsertProfile(res.user!);
  }

  /// Upsert a minimal profile row after successful auth.
  Future<void> _upsertProfile(User user) async {
    try {
      await Supabase.instance.client.from('profiles').upsert({
        'id': user.id,
        'phone': user.phone,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');
    } catch (_) {
      // Non-critical — table may not exist yet; ignore silently
    }
  }

  // ── Email Auth (Legacy compatibility) ────────────────────────────────────

  Future<void> signIn(String email, String password) async {
    final res = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    state = res.user;
  }

  Future<void> signUp(String email, String password) async {
    final res = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
    state = res.user;
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

/// Convenience provider — current logged-in user.
final currentUserProvider = Provider<User?>((ref) => ref.watch(authProvider));




