import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_widgets/src/utils/utils.dart';
import 'package:flutter/scheduler.dart';
import 'package:pausable_timer/pausable_timer.dart';

import 'toast.dart';
import 'toast_intent.dart';
import 'toast_theme.dart';

/// The visual toast notification widget.
class ToastWidget extends StatefulWidget {
  const ToastWidget({
    super.key,
    required this.toast,
    required this.onDismiss,
    required this.animationDuration,
  });

  final Toast toast;
  final VoidCallback onDismiss;
  final Duration animationDuration;

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> {
  double _opacity = 0;
  PausableTimer? _timer;

  @override
  void initState() {
    super.initState();
    _fadeIn();
  }

  void _fadeIn() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _opacity = 1;
      });
      if (widget.toast.timeout != null) {
        _timer = PausableTimer(widget.toast.timeout!, _fadeOut)..start();
      }
    });
  }

  void _fadeOut() {
    setState(() {
      _opacity = 0;
    });
  }

  void _onFadeComplete() {
    if (_opacity == 0) {
      widget.onDismiss();
    }
  }

  void _pauseTimer() => _timer?.pause();
  void _resumeTimer() => _timer?.start();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final toastTheme = ToastTheme.of(context);

    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.animationDuration,
      onEnd: _onFadeComplete,
      child: MouseRegion(
        onEnter: (_) => _pauseTimer(),
        onExit: (_) => _resumeTimer(),
        child: GestureDetector(
          // Touch devices won't trigger onEnter/onExit
          onLongPressStart: (_) => _pauseTimer(),
          onLongPressEnd: (_) => _resumeTimer(),
          onHorizontalDragEnd: (details) {
            // Swipe to dismiss
            if (details.primaryVelocity != null &&
                details.primaryVelocity!.abs() > 500) {
              widget.onDismiss();
            }
          },
          child: Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: _getBackgroundColor(theme, toastTheme),
              borderRadius: BorderRadius.circular(4),

              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_shouldShowIcon()) ...[
                    _buildIcon(theme, toastTheme),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.toast.title,
                          style: _getTitleStyle(theme, toastTheme),
                        ),
                        if (widget.toast.content != null) ...[
                          const SizedBox(height: 4),
                          DefaultTextStyle.merge(
                            style: _getBodyStyle(theme, toastTheme),
                            child: widget.toast.content!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (widget.toast.dismissible &&
                      widget.toast.trailing == null) ...[
                    const SizedBox(width: 8),
                    _buildDismissButton(theme),
                  ],
                  if (widget.toast.trailing != null) ...[
                    const SizedBox(width: 8),
                    widget.toast.trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowIcon() {
    return widget.toast.icon != null || _getDefaultIcon() != null;
  }

  Widget _buildIcon(FluentThemeData theme, ToastThemeData toastTheme) {
    final icon = widget.toast.icon ?? Icon(_getDefaultIcon());

    return IconTheme.merge(
      data: IconThemeData(size: 14, color: _getIconColor(theme, toastTheme)),
      child: icon,
    );
  }

  IconData? _getDefaultIcon() {
    switch (widget.toast.intent) {
      case ToastIntent.info:
        return FluentIcons.info;
      case ToastIntent.success:
        return FluentIcons.completed;
      case ToastIntent.warning:
        return FluentIcons.warning;
      case ToastIntent.error:
        return FluentIcons.error;
    }
  }

  Brightness _resolvedBrightness(FluentThemeData theme) {
    return widget.toast.inverted ? theme.brightness.inverted : theme.brightness;
  }

  Color _getIconColor(FluentThemeData theme, ToastThemeData toastTheme) {
    switch (widget.toast.intent) {
      case ToastIntent.info:
        return toastTheme.infoIconColor ?? theme.accentColor;
      case ToastIntent.success:
        return toastTheme.successIconColor ??
            (theme.brightness == Brightness.dark
                ? const Color(0xFF107C10)
                : const Color(0xFF107C10));
      case ToastIntent.warning:
        return toastTheme.warningIconColor ??
            (theme.brightness == Brightness.dark
                ? const Color(0xFFFFB900)
                : const Color(0xFFFFB900));
      case ToastIntent.error:
        return toastTheme.dangerIconColor ??
            (theme.brightness == Brightness.dark
                ? const Color(0xFFD13438)
                : const Color(0xFFD13438));
    }
  }

  Color _getBackgroundColor(FluentThemeData theme, ToastThemeData toastTheme) {
    return toastTheme.backgroundColor ??
        (_resolvedBrightness(theme) == Brightness.dark
            ? const Color(0xFF292929)
            : const Color(0xFFFFFFFF));
  }

  TextStyle _getTitleStyle(FluentThemeData theme, ToastThemeData toastTheme) {
    return toastTheme.titleStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _resolvedBrightness(theme) == Brightness.dark
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF000000),
        );
  }

  TextStyle _getBodyStyle(FluentThemeData theme, ToastThemeData toastTheme) {
    return toastTheme.subtitleStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _resolvedBrightness(theme) == Brightness.dark
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF616161),
        );
  }

  Widget _buildDismissButton(FluentThemeData theme) {
    return IconButton(
      icon: const Icon(FluentIcons.clear),
      onPressed: widget.onDismiss,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.all(4)),
      ),
    );
  }
}
