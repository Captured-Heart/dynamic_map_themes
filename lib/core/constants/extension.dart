import 'dart:developer';

import 'package:flutter/foundation.dart';

extension StringExtension on String {
  void logError({String? name}) => kDebugMode ? log(this, name: name ?? '') : null;
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
