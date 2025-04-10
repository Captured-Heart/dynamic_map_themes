import 'package:dynamic_map_themes/presentation/widgets/floating_themes_btn.dart';
import 'package:dynamic_map_themes/provider/map_styles_provider.dart';
import 'package:dynamic_map_themes/provider/map_view_provider.dart';
import 'package:dynamic_map_themes/repository/map_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({
    super.key,
  });

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  @override
  void initState() {
    ref.read(mapRepositoryProvider).getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapStyles = ref.watch(mapStyleProvider).mapStyle;
    final mapView = ref.watch(mapViewProvider);
    return Scaffold(
      key: UniqueKey(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: FloatingThemeBtnsWidget(),
      body: mapView.when(
        data: (data) {
          return GoogleMap(
            // key: UniqueKey(),
            initialCameraPosition: CameraPosition(
              target: LatLng(data.latitude, data.longitude),
              zoom: 13,
            ),
            style: mapStyles.isEmpty == true ? null : mapStyles,
            myLocationButtonEnabled: false,
            markers: const {},
            polylines: const {},
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (controller) {
              ref.read(mapRepositoryProvider).setMapController(controller);
            },
            onCameraMove: (position) {},
            onCameraMoveStarted: () {},
            myLocationEnabled: true,
          );
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text(
              'Please enable your location, and try again!',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
