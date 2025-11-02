import 'dart:ui';

extension InvertedBrightness on Brightness {
  Brightness get inverted =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}
