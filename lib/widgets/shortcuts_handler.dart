import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keyboard Shortcuts Handler
class ShortcutsHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback?  onStart;
  final VoidCallback?  onPause;
  final VoidCallback? onReset;

  const ShortcutsHandler({
    super.key,
    required this.child,
    this.onStart,
    this.onPause,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          // Space:  Start/Pause
          if (event.logicalKey == LogicalKeyboardKey.space) {
            if (onStart != null) onStart!();
            return KeyEventResult.handled;
          }

          // R: Reset
          if (event. logicalKey == LogicalKeyboardKey.keyR) {
            if (onReset != null) onReset!();
            return KeyEventResult.handled;
          }

          // Escape: Pause
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            if (onPause != null) onPause!();
            return KeyEventResult. handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child:  child,
    );
  }
}