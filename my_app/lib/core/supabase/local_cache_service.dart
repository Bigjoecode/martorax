import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheService {
  static const String _keyMarketPrices = 'cache_market_prices';
  static const String _keyTransactions = 'cache_transactions';
  static const String _keyProducts = 'cache_products';

  // Core Generic Caching methods with TTL (Time-To-Live)
  Future<void> _setCache({
    required String key,
    required dynamic data,
    int ttlSeconds = 86400, // 24-hour default expiration
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheObj = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'ttl': ttlSeconds,
        'payload': data,
      };
      await prefs.setString(key, jsonEncode(cacheObj));
    } catch (e) {
      // Graceful fallback for absolute reliability
      debugPrint('LocalCacheService: Failed to save cache for $key: $e');
    }
  }

  Future<dynamic> _getCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawStr = prefs.getString(key);
      if (rawStr == null) return null;

      final Map<String, dynamic> cacheObj = jsonDecode(rawStr);
      final int timestamp = cacheObj['timestamp'] as int;
      final int ttl = cacheObj['ttl'] as int;
      final dynamic payload = cacheObj['payload'];

      final ageSeconds = (DateTime.now().millisecondsSinceEpoch - timestamp) / 1000;
      if (ageSeconds > ttl) {
        // Cache has expired, clean up and return null to trigger network fetch
        await prefs.remove(key);
        return null;
      }

      return payload;
    } catch (e) {
      debugPrint('LocalCacheService: Failed to fetch cache for $key: $e');
      return null;
    }
  }

  // ==========================================
  // Market price board Cache (Sprint 4)
  // ==========================================
  Future<void> cacheMarketPrices(List<Map<String, dynamic>> prices) async {
    await _setCache(
      key: _keyMarketPrices,
      data: prices,
      ttlSeconds: 43200, // 12-hour shelf-life for daily price boards
    );
  }

  Future<List<Map<String, dynamic>>?> getCachedMarketPrices() async {
    final payload = await _getCache(_keyMarketPrices);
    if (payload == null) return null;
    try {
      return (payload as List).map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // Transactions & Safepay Escrows Cache
  // ==========================================
  Future<void> cacheTransactions(List<Map<String, dynamic>> transactions) async {
    await _setCache(
      key: _keyTransactions,
      data: transactions,
      ttlSeconds: 7200, // 2-hour refresh loop
    );
  }

  Future<List<Map<String, dynamic>>?> getCachedTransactions() async {
    final payload = await _getCache(_keyTransactions);
    if (payload == null) return null;
    try {
      return (payload as List).map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // Products Wholesale Cache
  // ==========================================
  Future<void> cacheProducts(List<Map<String, dynamic>> products) async {
    await _setCache(
      key: _keyProducts,
      data: products,
      ttlSeconds: 86400, // 24 hours
    );
  }

  Future<List<Map<String, dynamic>>?> getCachedProducts() async {
    final payload = await _getCache(_keyProducts);
    if (payload == null) return null;
    try {
      return (payload as List).map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (_) {
      return null;
    }
  }

  // Clear cache completely (useful on logout)
  Future<void> clearAllCaches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyMarketPrices);
    await prefs.remove(_keyTransactions);
    await prefs.remove(_keyProducts);
  }
}
