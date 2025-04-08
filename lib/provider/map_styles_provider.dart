import 'package:dynamic_map_themes/core/constants/asset_images.dart';
import 'package:dynamic_map_themes/core/enums/map_enums.dart';
import 'package:dynamic_map_themes/utils/shared_pref_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapStyleProvider = NotifierProvider<MapNotifier, MapStylesState>(
  () => MapNotifier(),
);
// final mapStyleProvider = Provider<String>((ref) {
//   final mapNotifier = ref.watch(mapProvider.notifier);
//   return mapNotifier.getSelectedMapStyle();
// });

class MapNotifier extends Notifier<MapStylesState> {
  @override
  build() {
    return MapStylesState(mapStyle: getSelectedMapStyle());
  }

  String getSelectedMapStyle() {
    String mapStyle = '';

    String? savedMapStyles = SharedPreferencesHelper.getString(key: SharedKeys.mapStyle.name);
    var mapStyleEnum = MapStyles.styleName(savedMapStyles ?? MapStyles.original.name);

    Future<String> selectedMapStyle() async {
      //
      await rootBundle.loadString(AssetImages.offlineMapStylesJson);
      return switch (mapStyleEnum) {
        MapStyles.dark => await rootBundle.loadString(AssetImages.darkMapStylesJson),
        MapStyles.night => await rootBundle.loadString(AssetImages.nightMapStylesJson),
        MapStyles.nightBlue => await rootBundle.loadString(AssetImages.nightBlueMapStylesJson),
        MapStyles.retro => await rootBundle.loadString(AssetImages.retroMapStylesJson),
        // ignore: null_argument_to_non_null_type
        MapStyles.original => await Future.value(''),
      };
    }

    selectedMapStyle().then((value) {
      mapStyle = value;
      state = state.copyWith(mapStyle: value);
    });

    return mapStyle;
  }

  Future<void> setMapStyles(String mapStyle) async {
    SharedPreferencesHelper.setString(key: SharedKeys.mapStyle.name, value: mapStyle);
    if (state.tapped == true) {}
    state = MapStylesState(mapStyle: getSelectedMapStyle());
  }
}

class MapStylesState {
  final String mapStyle;
  final bool tapped, isOffline;

  MapStylesState({
    this.mapStyle = '',
    this.tapped = false,
    this.isOffline = false,
  });

  MapStylesState copyWith({
    String? mapStyle,
    bool? tapped,
    bool? isOffline,
  }) {
    return MapStylesState(
      mapStyle: mapStyle ?? this.mapStyle,
      isOffline: isOffline ?? this.isOffline,
      tapped: tapped ?? this.tapped,
    );
  }
}
