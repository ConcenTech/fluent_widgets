import 'package:flutter/material.dart';

class EnabledMouseRegion extends StatelessWidget {
  const EnabledMouseRegion({
    super.key,
    required this.enabled,
    required this.onChanged,
    required this.child,
  });

  final bool enabled;
  final void Function(bool entered) onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => onChanged(true) : null,
      onExit: enabled ? (_) => onChanged(false) : null,
      child: child,
    );
  }
}
