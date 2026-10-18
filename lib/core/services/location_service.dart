import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationDataResult {
  final double latitude;
  final double longitude;
  final double accuracy;

  LocationDataResult({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });
}

class LocationService {
  // Default fallback (e.g. Cairo coordinates for Arabic region demo, or Riyadh)
  static const double fallbackLat = 30.0444;
  static const double fallbackLng = 31.2357;

  /// Check permissions and request if needed
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('[LocationService] Location services are disabled.');
        return false;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('[LocationService] Location permissions are denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('[LocationService] Location permissions are permanently denied');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('[LocationService] Permission check error (e.g. web/desktop): $e');
      return true;
    }
  }

  /// Get current single position
  static Future<LocationDataResult> getCurrentLocation() async {
    try {
      final hasPermission = await handleLocationPermission();
      if (!hasPermission) {
        return LocationDataResult(
          latitude: fallbackLat,
          longitude: fallbackLng,
          accuracy: 10.0,
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );

      return LocationDataResult(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    } catch (e) {
      debugPrint('[LocationService] Error fetching current location: $e. Using fallback.');
      return LocationDataResult(
        latitude: fallbackLat,
        longitude: fallbackLng,
        accuracy: 15.0,
      );
    }
  }

  /// Listen to live location updates stream
  static Stream<LocationDataResult> getLocationStream() {
    try {
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // update every 5 meters
      );

      return Geolocator.getPositionStream(locationSettings: locationSettings).map(
        (pos) => LocationDataResult(
          latitude: pos.latitude,
          longitude: pos.longitude,
          accuracy: pos.accuracy,
        ),
      );
    } catch (e) {
      debugPrint('[LocationService] Stream init error: $e');
      return Stream.periodic(const Duration(seconds: 10), (count) {
        // slight jitter to simulate movement in mock / web
        final jitter = (count % 5) * 0.0002;
        return LocationDataResult(
          latitude: fallbackLat + jitter,
          longitude: fallbackLng + jitter,
          accuracy: 10.0,
        );
      });
    }
  }
}
