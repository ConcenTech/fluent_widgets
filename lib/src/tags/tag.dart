import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

import '../utils/enabled_gesture_detector.dart';
import '../utils/enabled_mouse_region.dart';
import 'tag_properties.dart';
import 'tag_shape.dart';
import 'tag_size.dart';
import 'tag_style.dart';

/// A Fluent design Tag component for displaying labeled information
///
/// Tags are used to categorize, label, or mark items. They can be used
/// for filtering, status indication, or simply as visual markers.
class Tag extends StatefulWidget {
  /// The text content of the tag
  final String text;

  /// Optional icon to display before the text
  final Widget? icon;

  /// A widget to display at the end of the tag, typically a dismiss button
  final Widget? trailing;

  /// Callback when the tag is tapped
  final VoidCallback? _onPressed;

  /// Callback when the tag is dismissed (for dismissible tags)
  final VoidCallback? _onDismissed;

  /// The visual style of the tag
  final TagStyle tagStyle;

  /// The size of the tag
  final TagSize size;

  /// The shape of the tag.
  ///
  /// Rounded or Circular
  final TagShape shape;

  /// Custom background color (overrides theme)
  final WidgetStateProperty<Color>? backgroundColor;

  /// Custom text color (overrides theme)
  final WidgetStateProperty<Color>? textColor;

  /// Custom border color (for outline style)
  final WidgetStateProperty<Color>? borderColor;

  final bool enabled;

  const Tag({
    super.key,
    required this.text,
    this.icon,
    this.trailing,
    this.tagStyle = TagStyle.filled,
    this.size = TagSize.medium,
    this.shape = TagShape.rounded,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.enabled = true,
  }) : _onPressed = null,
       _onDismissed = null;

  const Tag._({
    super.key,
    required this.text,
    this.icon,
    this.trailing,
    VoidCallback? onPressed,
    VoidCallback? onDismissed,
    this.tagStyle = TagStyle.filled,
    this.size = TagSize.medium,
    this.shape = TagShape.rounded,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.enabled = true,
  }) : _onPressed = onPressed,
       _onDismissed = onDismissed;

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  /// Is the tag as a whole enabled
  bool get _isEnabled => widget.enabled;

  /// Should the main area react to states
  bool get _isInteractive => _isEnabled && widget._onPressed != null;

  /// Should the trailing area react to states
  bool get _isDismissible =>
      _isEnabled && (widget._onDismissed != null || widget.trailing != null);

  /// If true, should draw a border around the entire tag, including trailing.
  bool get _shouldDrawBorder => widget.tagStyle == TagStyle.outline;

  late final Set<WidgetState> _mainStates = {
    if (!_isEnabled) WidgetState.disabled,
  };

  late final Set<WidgetState> _trailingStates = {
    if (!_isEnabled) WidgetState.disabled,
  };

  void _updateMainState(WidgetState state, bool active) {
    setState(() {
      if (active) {
        _mainStates.add(state);
      } else {
        _mainStates.remove(state);
      }
    });
  }

  void _updateTrailingState(WidgetState state, bool active) {
    setState(() {
      if (active) {
        _trailingStates.add(state);
      } else {
        _trailingStates.remove(state);
      }
    });
  }

  void _updateMainFocus(bool focused) =>
      _updateMainState(WidgetState.focused, focused);

  void _updateMainHover(bool hovered) =>
      _updateMainState(WidgetState.hovered, hovered);

  void _updateMainPressed(bool pressed) =>
      _updateMainState(WidgetState.pressed, pressed);

  void _updateTrailingFocus(bool focused) =>
      _updateTrailingState(WidgetState.focused, focused);

  void _updateTrailingHover(bool hovered) =>
      _updateTrailingState(WidgetState.hovered, hovered);

  void _updateTrailingPressed(bool pressed) =>
      _updateTrailingState(WidgetState.pressed, pressed);

  KeyEventResult _onKeyEvent(KeyEvent event, bool isMain) {
    if ((isMain && !_isInteractive) || (!isMain && !_isDismissible)) {
      return KeyEventResult.ignored;
    }

    final enabledKeys = [LogicalKeyboardKey.enter, LogicalKeyboardKey.space];

    if (enabledKeys.contains(event.logicalKey)) {
      if (event is KeyDownEvent) {
        if (isMain) {
          _updateMainPressed(true);
        } else {
          _updateTrailingPressed(true);
        }
      } else if (event is KeyUpEvent) {
        if (isMain) {
          _updateMainPressed(false);
          widget._onPressed?.call();
        } else {
          _updateTrailingPressed(false);
          widget._onDismissed?.call();
        }
      }
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape && event is KeyUpEvent) {
      _removeFocus();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _removeFocus() {
    _mainFocusNode.unfocus();
    _trailingFocusNode.unfocus();
  }

  @override
  void didUpdateWidget(Tag oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isEnabled) {
      _mainStates.remove(WidgetState.disabled);
      _trailingStates.remove(WidgetState.disabled);
    } else {
      _mainStates.add(WidgetState.disabled);
      _trailingStates.add(WidgetState.disabled);
    }
  }

  late final _mainFocusNode = FocusNode();
  late final _trailingFocusNode = FocusNode();

  @override
  void dispose() {
    _mainFocusNode.dispose();
    _trailingFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = widget.size.dimensions;
    final borderRadius = dimensions.radius(widget.shape);

    final backgroundColor =
        widget.backgroundColor ??
        buildBackgroundColor(context, widget.tagStyle);
    final foregroundColor =
        widget.textColor ?? buildForegroundColor(context, widget.tagStyle);
    final borderColor =
        (widget.borderColor ?? buildBorderColor(context, widget.tagStyle))
            .resolve(_mainStates);

    final hasTrailing = widget.trailing != null || widget._onDismissed != null;

    Widget mainContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          IconTheme(
            data: IconThemeData(
              size: dimensions.iconSize,
              fill: _mainStates.contains(WidgetState.hovered) ? 1.0 : 0.0,
              color: foregroundColor.resolve(_mainStates),
            ),
            child: widget.icon!,
          ),
          SizedBox(width: dimensions.iconSpacing),
        ],
        Text(
          widget.text,
          style: FluentTheme.of(context).typography.body!.copyWith(
            fontSize: dimensions.fontSize,
            color: foregroundColor.resolve(_mainStates),
          ),
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: _shouldDrawBorder
            ? Border.all(color: borderColor, width: 1.0)
            : null,
        color: !_isEnabled ? backgroundColor.resolve(_mainStates) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main content area
          Flexible(
            child: Focus(
              focusNode: _mainFocusNode,
              canRequestFocus: _isInteractive,
              onFocusChange: _updateMainFocus,
              onKeyEvent: (_, event) => _onKeyEvent(event, true),
              child: EnabledMouseRegion(
                enabled: _isInteractive,
                onChanged: (entered) => _updateMainHover(entered),
                child: EnabledGestureDetector(
                  enabled: _isInteractive,
                  onTap: widget._onPressed,
                  onTapChanged: (pressed) => _updateMainPressed(pressed),

                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: dimensions.horizontalPadding,
                      vertical: dimensions.verticalPadding,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor.resolve(_mainStates),
                      border: buildBorder(context).resolve(_mainStates),
                      borderRadius: hasTrailing
                          ? BorderRadius.only(
                              topLeft: Radius.circular(borderRadius),
                              bottomLeft: Radius.circular(borderRadius),
                            )
                          : BorderRadius.circular(borderRadius),
                    ),
                    child: mainContent,
                  ),
                ),
              ),
            ),
          ),
          // Trailing area (if present)
          if (hasTrailing) ...[
            // Visual separator
            if (_isInteractive)
              Container(
                width: 1,
                height:
                    dimensions.iconSize + (dimensions.iconVerticalPadding * 2),
                color: foregroundColor
                    .resolve(_mainStates)
                    .withValues(alpha: 0.2),
              ),
            // Trailing button area
            Focus(
              focusNode: _trailingFocusNode,
              canRequestFocus: _isDismissible,
              onFocusChange: _updateTrailingFocus,
              onKeyEvent: (node, event) => _onKeyEvent(event, false),
              child: EnabledMouseRegion(
                enabled: _isDismissible,
                onChanged: (entered) => _updateTrailingHover(entered),
                child: EnabledGestureDetector(
                  enabled: _isDismissible,
                  onTap: widget._onDismissed,
                  onTapChanged: (bool pressed) =>
                      _updateTrailingPressed(pressed),

                  child: Container(
                    width: dimensions.iconSize + dimensions.horizontalPadding,
                    height:
                        dimensions.iconSize +
                        (dimensions.iconVerticalPadding * 2),
                    decoration: BoxDecoration(
                      color: backgroundColor.resolve(_trailingStates),
                      border: buildBorder(context).resolve(_trailingStates),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                    ),
                    child: IconTheme(
                      data: IconThemeData(
                        size: dimensions.iconSize,
                        // weight: 100,
                        color: buildForegroundColor(
                          context,
                          widget.tagStyle,
                          widget._onDismissed != null,
                        ).resolve(_trailingStates),
                      ),
                      child:
                          widget.trailing ??
                          const Icon(FluentIcons.calculator_multiply),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A dismissible tag that shows a close button
class DismissibleTag extends Tag {
  const DismissibleTag({
    super.key,
    required super.text,
    super.icon,
    super.tagStyle,
    super.size,
    super.shape,
    super.backgroundColor,
    super.textColor,
    super.borderColor,
    required VoidCallback onDismiss,
    super.enabled,
  }) : super._(onDismissed: onDismiss);
}

class InteractiveTag extends Tag {
  const InteractiveTag({
    super.key,
    required super.text,
    super.icon,
    required VoidCallback onPressed,
    super.tagStyle,
    super.size,
    super.shape,
    super.backgroundColor,
    super.textColor,
    super.borderColor,
    super.enabled,
  }) : super._(onPressed: onPressed);
}

class DismissibleInteractiveTag extends Tag {
  const DismissibleInteractiveTag({
    super.key,
    required super.text,
    super.icon,
    required VoidCallback onPressed,
    super.tagStyle,
    super.size,
    super.shape,
    super.backgroundColor,
    super.textColor,
    super.borderColor,
    required VoidCallback onDismiss,
    super.enabled,
  }) : super._(onDismissed: onDismiss, onPressed: onPressed);
}
