import 'package:flutter/material.dart' hide Theme;
import 'package:fluent_ui/fluent_ui.dart';

/// Theme data for toast notifications.
class ToastThemeData {
  const ToastThemeData({
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.infoIconColor,
    this.successIconColor,
    this.warningIconColor,
    this.dangerIconColor,
  });

  /// Background color for toasts.
  final Color? backgroundColor;

  /// Text style for toast titles.
  final TextStyle? titleStyle;

  /// Text style for toast subtitles.
  final TextStyle? subtitleStyle;

  /// Icon color for info toasts.
  final Color? infoIconColor;

  /// Icon color for success toasts.
  final Color? successIconColor;

  /// Icon color for warning toasts.
  final Color? warningIconColor;

  /// Icon color for danger toasts.
  final Color? dangerIconColor;

  ToastThemeData copyWith({
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    Color? infoIconColor,
    Color? successIconColor,
    Color? warningIconColor,
    Color? dangerIconColor,
  }) {
    return ToastThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      infoIconColor: infoIconColor ?? this.infoIconColor,
      successIconColor: successIconColor ?? this.successIconColor,
      warningIconColor: warningIconColor ?? this.warningIconColor,
      dangerIconColor: dangerIconColor ?? this.dangerIconColor,
    );
  }
}

/// Provides toast theme data via [BuildContext].
class ToastTheme extends InheritedWidget {
  const ToastTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final ToastThemeData data;

  static ToastThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<ToastTheme>();
    return widget?.data ?? const ToastThemeData();
  }

  @override
  bool updateShouldNotify(ToastTheme oldWidget) {
    return data != oldWidget.data;
  }
}

