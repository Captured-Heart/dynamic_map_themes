import 'package:dynamic_map_themes/core/constants/extension.dart';
import 'package:dynamic_map_themes/core/enums/map_enums.dart';
import 'package:dynamic_map_themes/provider/map_styles_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingThemeBtnsWidget extends ConsumerWidget {
  FloatingThemeBtnsWidget({
    super.key,
  });

  final _key = GlobalKey<ExpandableFabState>();
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
      // _ => Icons.sunny,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpandableFab(
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
    );
  }
}
