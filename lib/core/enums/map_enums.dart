enum MapStyles {
  original,
  // offline,
  dark,
  night,
  nightBlue,
  retro;

  static MapStyles styleName(String style) => MapStyles.values.firstWhere((e) => e.name == style, orElse: () => MapStyles.original);
}
