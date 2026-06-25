import 'dart:async';
import 'supabase_config.dart';

class GpsTrackingService {
  // Coordinates representing key hubs in Asaba, Nigeria
  static const double ogbogonogoMarketLat = 6.2054;
  static const double ogbogonogoMarketLng = 6.7291;
  static const double nnebisiJunctionLat = 6.1950;
  static const double nnebisiJunctionLng = 6.7150;

  // Intermediate route path from Ogbogonogo to Nnebisi Junction for high-fidelity path simulations
  final List<Map<String, double>> _asabaRoutePath = [
    {'latitude': 6.2054, 'longitude': 6.7291, 'bearing': 225.0}, // Ogbogonogo Hub Start
    {'latitude': 6.2030, 'longitude': 6.7260, 'bearing': 230.0},
    {'latitude': 6.2005, 'longitude': 6.7225, 'bearing': 228.0}, // Passing Summit Road crossing
    {'latitude': 6.1975, 'longitude': 6.7180, 'bearing': 226.0},
    {'latitude': 6.1950, 'longitude': 6.7150, 'bearing': 225.0}, // Arrived at Nnebisi Junction destination
  ];

  // 1. Stream simulated live GPS coordinates (for UI live tracking maps)
  Stream<Map<String, double>> streamRiderLocation(String orderId) {
    late StreamController<Map<String, double>> controller;
    Timer? timer;
    int routeIndex = 0;

    controller = StreamController<Map<String, double>>(
      onListen: () {
        // Emit coordinates sequentially every 3 seconds to simulate a live moving rider
        timer = Timer.periodic(const Duration(seconds: 3), (t) async {
          if (routeIndex >= _asabaRoutePath.length) {
            timer?.cancel();
            controller.close();
            return;
          }

          final currentPos = _asabaRoutePath[routeIndex];
          controller.add(currentPos);

          // Attempt to sync location to Supabase table in background
          _syncLocationToSupabase(
            orderId: orderId,
            lat: currentPos['latitude']!,
            lng: currentPos['longitude']!,
            bearing: currentPos['bearing']!,
          );

          routeIndex++;
        });
      },
      onCancel: () {
        timer?.cancel();
      },
    );

    return controller.stream;
  }

  // 2. Push coordinate packets to Supabase
  Future<void> _syncLocationToSupabase({
    required String orderId,
    required double lat,
    required double lng,
    required double bearing,
  }) async {
    try {
      await SupabaseConfig.client.from('rider_tracking').insert({
        'rider_id': 'current_rider_placeholder_uuid',
        'order_id': orderId,
        'latitude': lat,
        'longitude': lng,
        'bearing': bearing,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Graceful sandbox offline wrapper
    }
  }

  // Get active coordinate board static details
  Map<String, double> getInitialHubCoordinates() {
    return {
      'latitude': ogbogonogoMarketLat,
      'longitude': ogbogonogoMarketLng,
    };
  }
}
