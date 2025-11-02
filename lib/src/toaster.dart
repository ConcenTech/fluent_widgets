import 'package:fluent_widgets/src/measured_widget.dart';
import 'package:fluent_widgets/src/toast.dart';
import 'package:fluent_widgets/src/toast_widget.dart';
import 'package:flutter/widgets.dart';

import 'toast_position.dart';

class ToasterProvider extends InheritedWidget {
  const ToasterProvider({
    super.key,
    required this.controller,
    required super.child,
  });
  final ToasterController controller;
  @override
  bool updateShouldNotify(ToasterProvider old) => controller != old.controller;
}

class ToasterController {
  ToasterController._({
    required this.dispatchToast,
    required this.dismissToast,
    required this.dismissAllToasts,
    required this.updateToast,
  });

  /// Adds a toast to the queue.
  ///
  /// If the queue is empty, or below the maximum number of toasts,
  /// the toast is shown immediately.
  final void Function(Toast item) dispatchToast;

  /// Dismisses a toast by its ID.
  final void Function(String id) dismissToast;

  /// Dismisses all toasts.
  final void Function() dismissAllToasts;

  /// Updates a toast by its ID.
  final void Function(Toast item) updateToast;
}

class Toaster extends StatefulWidget {
  const Toaster({
    super.key,
    required this.child,
    this.maxToasts = 3,
    this.animationDuration = const Duration(milliseconds: 400),
    this.position = ToastPosition.bottomEnd,
    this.offset = const Offset(5, 5),
  });

  /// The widget tree below this toaster.
  final Widget child;

  /// Maximum number of toasts to display simultaneously.
  final int maxToasts;

  /// The offset of the toasts from the edge of the screen.
  final Offset offset;

  /// Toasts can be dispatched from all four corners of the page.
  ///
  /// It's not recommended to use more than one position for toasts in an
  /// application  because it could be disorienting for the user.
  ///
  /// Pick one desired position and configure it in the [Toaster].
  final ToastPosition position;

  final Duration animationDuration;

  @override
  State<Toaster> createState() => _ToasterState();

  static ToasterController? maybeOf(BuildContext context) {
    final widget = context.findAncestorStateOfType<_ToasterState>();
    return widget?._controller;
  }

  /// Retrieves the [ToastController] from the nearest [Toaster] ancestor.
  ///
  /// Throws if no [Toaster] is found in the widget tree.
  static ToasterController of(BuildContext context) {
    final controller = maybeOf(context);
    if (controller == null) {
      throw FlutterError(
        'Toaster.of(context) called with a context that does not contain a Toaster.\n'
        'No ancestor could be found starting from the context that was passed to Toaster.of().\n'
        'Wrap your app with Toaster widget to enable toast notifications.',
      );
    }
    return controller;
  }
}

class _ToasterState extends State<Toaster> {
  late final ToasterController _controller;

  final List<Toast> _visible = [];
  final List<Toast> _queue = [];
  final Map<String, double> _heights = {};

  // Determine if we're positioning from top or bottom
  bool get isTopPosition =>
      widget.position == ToastPosition.top ||
      widget.position == ToastPosition.topStart ||
      widget.position == ToastPosition.topEnd;

  // Determine horizontal alignment
  bool get isLeftAlignment =>
      widget.position == ToastPosition.topStart ||
      widget.position == ToastPosition.bottomStart;
  bool get isRightAlignment =>
      widget.position == ToastPosition.topEnd ||
      widget.position == ToastPosition.bottomEnd;

  @override
  void initState() {
    super.initState();
    _controller = ToasterController._(
      dispatchToast: _addItem,
      dismissToast: _removeItem,
      dismissAllToasts: _removeAll,
      updateToast: _updateToast,
    );
  }

  void _removeAll() {
    setState(() {
      _visible.clear();
      _queue.clear();
      _heights.clear();
    });
  }

  void _addItem(Toast toast) {
    if (_visible.length >= widget.maxToasts) {
      // Queue it instead of adding
      setState(() => _queue.add(toast));
    } else {
      // Add immediately
      setState(() => _visible.add(toast));
    }
  }

  void _removeItem(String id) {
    final index = _visible.indexWhere((e) => e.id == id);
    if (index == -1) return;

    setState(() {
      _heights.remove(id);
      _visible.removeWhere((e) => e.id == id);
      _queue.removeWhere((e) => e.id == id);
    });
    _tryDequeue(); // Try adding from queue after removal
  }

  void _tryDequeue() {
    if (_queue.isEmpty) return;
    if (_visible.length >= widget.maxToasts) return;

    final next = _queue.removeAt(0);
    setState(() {
      _visible.add(next);
    });
  }

  void _updateToast(Toast toast) {
    var index = _visible.indexWhere((e) => e.id == toast.id);
    if (index > -1) {
      setState(() {
        _visible[index] = toast;
      });
    }

    index = _queue.indexWhere((e) => e.id == toast.id);
    if (index > -1) {
      _queue[index] = toast;
    }
  }

  Map<String, Offset> _computeOffsets(double screenWidth, double screenHeight) {
    final positions = <String, Offset>{};

    // Toast widget width (from ToastWidget)
    const toastWidth = 300.0;

    // Calculate base x offset
    double baseX;
    if (isLeftAlignment || isRightAlignment) {
      baseX = widget.offset.dx;
    } else {
      // Center alignment: account for toast width
      baseX = (screenWidth - toastWidth) / 2 + widget.offset.dx;
    }

    // Calculate vertical offset accumulation
    double accumulatedOffset = widget.offset.dy;
    const gapBetweenItems = 5.0;

    // Iterate items in reverse order for both cases
    // For top positions: newest at top, older items stack below
    // For bottom positions: newest at bottom, older items stack above
    for (final item in _visible.reversed) {
      final height = _heights[item.id] ?? 0;

      positions[item.id] = Offset(baseX, accumulatedOffset);
      accumulatedOffset += height + gapBetweenItems;
    }

    return positions;
  }

  @override
  Widget build(BuildContext context) {
    return ToasterProvider(
      controller: _controller,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final positions = _computeOffsets(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          return Stack(
            children: [
              widget.child,
              for (final item in _visible)
                AnimatedPositioned(
                  key: ValueKey(item.id),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  top: isTopPosition ? positions[item.id]?.dy : null,
                  bottom: !isTopPosition ? positions[item.id]?.dy : null,
                  left:
                      isLeftAlignment ||
                          (widget.position == ToastPosition.top ||
                              widget.position == ToastPosition.bottom)
                      ? positions[item.id]?.dx
                      : null,
                  right: isRightAlignment ? positions[item.id]?.dx : null,
                  child: AnimatedOpacity(
                    opacity: 1,
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    child: MeasuredChild(
                      onHeight: (h) {
                        if (_heights[item.id] != h) {
                          setState(() => _heights[item.id] = h);
                        }
                      },
                      child: ToastWidget(
                        toast: item,
                        onDismiss: () => _removeItem(item.id),
                        animationDuration: widget.animationDuration,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
