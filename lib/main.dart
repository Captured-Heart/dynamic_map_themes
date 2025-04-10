import 'package:dynamic_map_themes/utils/shared_pref_helper.dart';
import 'package:dynamic_map_themes/presentation/views/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
