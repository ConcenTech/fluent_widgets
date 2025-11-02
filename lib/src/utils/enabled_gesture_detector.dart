import 'package:flutter/material.dart';

class EnabledGestureDetector extends StatelessWidget {
  const EnabledGestureDetector({
    super.key,
    required this.enabled,
    required this.onTap,
    required this.onTapChanged,
    required this.child,
  });

  final bool enabled;
  final VoidCallback? onTap;
  final void Function(bool pressed) onTapChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      onTapDown: enabled ? (details) => onTapChanged(true) : null,
      onTapUp: enabled ? (details) => onTapChanged(false) : null,
      onTapCancel: enabled ? () => onTapChanged(false) : null,
      child: child,
    );
  }
}
