import 'package:dynamic_map_themes/core/constants/extension.dart';
import 'package:dynamic_map_themes/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepositoryImpl();
});

abstract class MapRepository {
  GoogleMapController setMapController(GoogleMapController controller);
  GoogleMapController? getMapController();
  (String, Stream<Position>) getLocationStream();
  Future<(String, Position?)> getCurrentLocation();
  Future<(String, bool)> locationPermissionStatus();
}

class MapRepositoryImpl implements MapRepository {
  GoogleMapController? _mapController;

  @override
  GoogleMapController? getMapController() {
    return _mapController;
  }

  @override
  GoogleMapController setMapController(GoogleMapController controller) {
    _mapController = controller;
    return controller;
  }

  @override
  (String, Stream<Position>) getLocationStream() {
    try {
      var position = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
      return ('', position);
    } catch (e) {
      return (e.toString(), const Stream.empty());
    }
  }

  @override
  Future<(String, Position?)> getCurrentLocation() async {
    var permission = await locationPermissionStatus();

    try {
      if (permission.$1.isNotEmpty) {
        throw permission.$1;
      }
      var position = await Geolocator.getCurrentPosition(locationSettings: locationSettings());
      'what is current popsition: ${position.toString()}'.logError(name: 'location_');
      SharedPreferencesHelper.setDouble(key: SharedKeys.lat.name, value: position.latitude);
      SharedPreferencesHelper.setDouble(key: SharedKeys.long.name, value: position.longitude);
      return ('', position);
    } catch (e) {
      return (e.toString(), null);
    }
  }

  @override
  Future<(String, bool)> locationPermissionStatus() async {
    'i am in the location oermission method:'.logError(name: 'location');
    try {
      var serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const ('Location services are disabled.', false);
      }
      var permission = await Geolocator.checkPermission();
      //IS ENABLED
      var isEnabled = serviceEnabled && (permission != LocationPermission.denied && permission != LocationPermission.deniedForever);

      'what is the permission: ${permission.name}'.logError(name: 'location_');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const ('Location permissions are denied', false);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const ('Location permissions are permanently denied, we cannot request permissions.', false);
      }
      return ('', isEnabled);
    } catch (e) {
      'i am in the left of location_status: $e'.logError(name: 'location_s');
      return ('$e', false);
    }
  }
}

LocationSettings locationSettings() {
  TargetPlatform targetPlatform = TargetPlatform.android;
  return switch (targetPlatform) {
    //! android
    TargetPlatform.android => AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
      ),

    //! ios || macos
    TargetPlatform.iOS || TargetPlatform.macOS => AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: true,
        timeLimit: const Duration(seconds: 60),
      ),

    //! default
    _ => const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      )
  };
}
