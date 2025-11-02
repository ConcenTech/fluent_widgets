import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'toast_intent.dart';

/// A toast notification to be displayed by a [Toaster].
///
/// Visually matches Fluent UI React Toast behavior.
class Toast {
  /// Creates a toast notification.
  Toast({
    required this.title,
    this.content,
    this.intent = ToastIntent.info,
    this.trailing,
    this.dismissible = true,
    this.inverted = false,
    this.timeout = const Duration(seconds: 3),
    this.icon,
    String? id,
  }) : id = id ?? Uuid().v4();

  /// The main title text of the toast.
  final String title;

  /// Optional widget shown below the title.
  final Widget? content;

  /// The visual intent/purpose of the toast.
  final ToastIntent intent;

  /// Whether the toast can be dismissed by the user.
  final bool dismissible;

  /// Whether the toast should be displayed in inverted mode.
  final bool inverted;

  /// Duration before auto-dismissing. If null, the toast persists until manually dismissed.
  final Duration? timeout;

  /// Optional custom icon widget.
  final Widget? icon;

  /// Replaces the dismiss button with a custom widget.
  ///
  /// Dismissing will need to be handled using `Toaster.of(context).remove(id)`.
  final Widget? trailing;

  /// Optional unique identifier for this toast.
  ///
  /// If provided, can be used to dismiss or update the toast later.
  final String id;
}
