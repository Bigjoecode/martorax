import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ==========================================
// 1. User Role Provider
// ==========================================
final userRoleProvider = StateProvider<String>((ref) => 'shopper');

// ==========================================
// 2. Global Cart State Management
// ==========================================
class CartItem {
  final String id;
  final String name;
  final double price;
  final String vendor;
  final int quantity;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.vendor,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      vendor: vendor,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    final existingIndex = state.indexWhere((i) => i.id == item.id);
    if (existingIndex >= 0) {
      final existing = state[existingIndex];
      state = [
        ...state.sublist(0, existingIndex),
        existing.copyWith(quantity: existing.quantity + 1),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, item];
    }
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
  }

  void clearCart() {
    state = [];
  }

  /// Remove every item belonging to a given vendor (matched by [CartItem.vendor]).
  /// Called after a successful per-vendor checkout to clear that group only.
  void removeVendorItems(String vendor) {
    state = state.where((i) => i.vendor != vendor).toList();
  }

  double get totalPrice {
    return state.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

/// The vendor whose items are currently being checked out. `null` means
/// "all items in cart" (single-vendor cart). Set by [CartScreen] when the
/// shopper taps a per-vendor checkout button; cleared after Paystack success.
final checkoutVendorProvider = StateProvider<String?>((ref) => null);

/// The cart items filtered by the in-flight checkout vendor.
/// Used by the checkout screens so the user only sees / pays for items
/// from the vendor they're checking out.
final activeCheckoutItemsProvider = Provider<List<CartItem>>((ref) {
  final cart = ref.watch(cartProvider);
  final vendor = ref.watch(checkoutVendorProvider);
  if (vendor == null) return cart;
  return cart.where((i) => i.vendor == vendor).toList();
});

// ==========================================
// 3. Persistent Language State Management (Phase 4)
// ==========================================
class LanguageNotifier extends StateNotifier<String> {
  static const String _prefKey = 'selected_language';
  
  LanguageNotifier() : super('English') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString(_prefKey);
      if (savedLang != null) {
        state = savedLang;
      }
    } catch (_) {
      // Fallback silently if shared preferences fails or isn't initialized yet
    }
  }

  Future<void> setLanguage(String language) async {
    state = language;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, language);
    } catch (_) {}
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});
