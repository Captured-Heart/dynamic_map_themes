import 'package:dynamic_map_themes/repository/map_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapViewProvider = StreamProvider<Position>(
  (ref) {
    GoogleMapController? mapController = ref.read(mapRepositoryProvider).getMapController();
    var repository = ref.read(mapRepositoryProvider).getLocationStream();
    return repository.$2.map(
      (position) {
        if (mapController == null) {
          return position;
        } else {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14,
              ),
            ),
          );
        }
        return position;
      },
    );
  },
);
