import 'package:fluent_ui/fluent_ui.dart';

import 'tag_style.dart';

const _filledButtonBackgroundLight = {
  WidgetState.disabled: Color(0xffbdbdbd),
  WidgetState.pressed: Color(0xffd6d6d6),
  WidgetState.focused: Color(0xffebebeb),
  WidgetState.hovered: Color(0xffebebeb),
  WidgetState.any: Color(0xfff5f5f5),
};

const _filledButtonBackgroundDark = {
  WidgetState.disabled: Color(0xff141414),
  WidgetState.pressed: Color(0xff0a0a0a),
  WidgetState.focused: Color(0xff292929),
  WidgetState.hovered: Color(0xff292929),
  WidgetState.any: Color(0xff141414),
};

const _outlineButtonBackgroundLight = {
  WidgetState.disabled: Colors.transparent,
  WidgetState.pressed: Color(0xffe0e0e0),
  WidgetState.focused: Color(0xfff5f5f5),
  WidgetState.hovered: Color(0xfff5f5f5),
  WidgetState.any: Colors.transparent,
};

const _outlineButtonBackgroundDark = {
  WidgetState.disabled: Colors.transparent,
  WidgetState.pressed: Color(0xff2e2e2e),
  WidgetState.focused: Color(0xff383838),
  WidgetState.hovered: Color(0xff383838),
  WidgetState.any: Colors.transparent,
};

WidgetStateProperty<Border?> buildBorder(BuildContext context) {
  final theme = FluentTheme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;
  final borderColor = isDarkMode ? Colors.white : Colors.black;

  return WidgetStateProperty.fromMap({
    WidgetState.focused: Border.all(color: borderColor, width: 1.0),
    WidgetState.any: null,
  });
}

WidgetStateProperty<Color> buildBorderColor(
  BuildContext context,
  TagStyle style,
) {
  switch (style) {
    case TagStyle.filled:
    case TagStyle.brand:
      return WidgetStatePropertyAll(Colors.transparent);
    case TagStyle.outline:
      final theme = FluentTheme.of(context);
      return WidgetStatePropertyAll(
        theme.resources.dividerStrokeColorDefault.withValues(alpha: 0.2),
      );
  }
}

WidgetStateProperty<Color> buildBackgroundColor(
  BuildContext context,
  TagStyle style,
) {
  final theme = FluentTheme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  switch (style) {
    case TagStyle.filled:
      if (isDarkMode) {
        return WidgetStateColor.fromMap(_filledButtonBackgroundDark);
      }
      return WidgetStateColor.fromMap(_filledButtonBackgroundLight);

    case TagStyle.outline:
      if (isDarkMode) {
        return WidgetStateColor.fromMap(_outlineButtonBackgroundDark);
      } else {
        return WidgetStateColor.fromMap(_outlineButtonBackgroundLight);
      }
    case TagStyle.brand:
      final baseColor = theme.accentColor;

      return WidgetStateProperty.fromMap({
        WidgetState.disabled: isDarkMode
            ? Color(0xff141414)
            : Color(0xffbdbdbd),
        WidgetState.pressed: baseColor.darkest.withValues(alpha: 0.1),
        WidgetState.focused: baseColor.withValues(alpha: 0.2),
        WidgetState.hovered: baseColor.withValues(alpha: 0.2),
        WidgetState.any: theme.accentColor.withValues(alpha: 0.1),
      });
  }
}

WidgetStateProperty<Color> buildForegroundColor(
  BuildContext context,
  TagStyle style, [
  bool isClose = false,
]) {
  final theme = FluentTheme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;
  final baseColor = theme.resources.textFillColorPrimary;
  final selectColor = theme.accentColor;
  final brightSelectColor = theme.accentColor.lightest;

  switch (style) {
    case TagStyle.filled:
    case TagStyle.outline:
      return WidgetStateProperty.fromMap({
        WidgetState.disabled: baseColor.withValues(alpha: 0.3),
        WidgetState.pressed: isClose ? selectColor : baseColor,
        WidgetState.focused: isClose ? selectColor : baseColor,
        WidgetState.hovered: isClose ? selectColor : baseColor,
        WidgetState.any: baseColor.withValues(alpha: 0.7),
      });
    case TagStyle.brand:
      return WidgetStateProperty.fromMap({
        WidgetState.disabled: baseColor.withValues(alpha: 0.3),

        WidgetState.any: isDarkMode ? brightSelectColor : selectColor,
      });
  }
}
