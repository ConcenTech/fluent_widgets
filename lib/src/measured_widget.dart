import 'package:flutter/widgets.dart';

/// Widget that reports its child's height
class MeasuredChild extends StatefulWidget {
  final Widget child;
  final ValueChanged<double> onHeight;
  const MeasuredChild({super.key, required this.child, required this.onHeight});

  @override
  State<MeasuredChild> createState() => _MeasuredChildState();
}

class _MeasuredChildState extends State<MeasuredChild> {
  final _key = GlobalKey();

  void _scheduleReport() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _report());
  }

  void _report() {
    final context = _key.currentContext;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox;
    widget.onHeight(box.size.height);
  }

  @override
  void initState() {
    super.initState();
    _scheduleReport();
  }

  @override
  void didUpdateWidget(covariant MeasuredChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleReport();
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: _key, child: widget.child);
  }
}
