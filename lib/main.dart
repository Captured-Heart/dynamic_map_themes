import 'package:dynamic_map_themes/core/enums/map_enums.dart';
import 'package:dynamic_map_themes/core/constants/extension.dart';
import 'package:dynamic_map_themes/provider/map_styles_provider.dart';
import 'package:dynamic_map_themes/provider/map_view_provider.dart';
import 'package:dynamic_map_themes/repository/map_repository.dart';
import 'package:dynamic_map_themes/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:web/web.dart' as web;

String get googleMapsApiKey => const String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: '');
void main() async {
  // web.document.getElementById('google-maps-script')?.setAttribute(
  //       'src',
  //       'https://maps.googleapis.com/maps/api/js?key=$googleMapsApiKey',
  //     );
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
      ),
      home: const MapView(),
    );
  }
}

class MapView extends ConsumerStatefulWidget {
  const MapView({
    super.key,
  });

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  Color textColor(MapStyles mapStyle) {
    return switch (mapStyle) {
      MapStyles.nightBlue => Colors.blue,
      MapStyles.retro => Colors.amber,
      MapStyles.night => Colors.blueGrey,
      _ => Colors.black,
    };
  }

  IconData styleIcons(MapStyles mapStyle) {
    return switch (mapStyle) {
      MapStyles.nightBlue => Icons.nightlight_outlined,
      MapStyles.night => Icons.dark_mode,
      MapStyles.retro => Icons.filter_vintage,
      MapStyles.dark => Icons.nights_stay_rounded,
      MapStyles.original => Icons.wb_sunny_outlined,
      _ => Icons.sunny,
    };
  }

  @override
  void initState() {
    ref.read(mapRepositoryProvider).getCurrentLocation();
    super.initState();
  }

  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    final mapStyles = ref.watch(mapStyleProvider).mapStyle;
    final mapView = ref.watch(mapViewProvider);
    return Scaffold(
      key: UniqueKey(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        type: ExpandableFabType.up,
        pos: ExpandableFabPos.right,
        fanAngle: 180,
        distance: 70,
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 2,
          color: Colors.black.withValues(alpha: 0.2),
        ),
        openButtonBuilder: FloatingActionButtonBuilder(
          size: 80,
          builder: (context, controller, _) {
            return const SizedBox.square(
              dimension: 60,
              child: Card(
                color: Colors.amberAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                elevation: 5,
                child: Icon(Icons.map),
              ),
            );
          },
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 80,
          builder: (context, controller, _) {
            return const SizedBox.square(
              dimension: 60,
              child: Card(
                color: Colors.amberAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                elevation: 5,
                child: Icon(Icons.close),
              ),
            );
          },
        ),
        children: [
          ...List.generate(
            MapStyles.values.length,
            (index) {
              final mapStyle = MapStyles.values[index];
              return FloatingActionButton.extended(
                backgroundColor: Colors.white,
                heroTag: mapStyle.name,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(
                    color: Colors.amberAccent,
                    width: 1,
                  ),
                ),
                onPressed: () {
                  final state = _key.currentState;
                  if (state != null) {
                    state.toggle();
                  }
                  ref.read(mapStyleProvider.notifier).setMapStyles(mapStyle.name);
                },
                label: Text(mapStyle.name.toTitleCase()),
                icon: Icon(styleIcons(mapStyle), color: textColor(mapStyle)),
              );
            },
          ),
        ],
      ),
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
