import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/app_colors.dart';
import '../../models/sort_state.dart';

/// Circular Visualization - Elements arranged in circle
class CircularVisualization extends StatelessWidget {
  final SortState sortState;

  const CircularVisualization({
    super.key,
    required this.sortState,
  });

  Color _getColor(int index) {
    final state = sortState.getBarState(index);
    
    switch (state) {
      case BarState.comparing:
        return AppColors.barComparing;
      case BarState.swapping:
        return AppColors.barSwapping;
      case BarState.sorted:
        return AppColors.barSorted;
      case BarState.pivot:
        return AppColors.barPivot;
      case BarState.selected:
        return AppColors.secondary;
      case BarState.normal:
        return AppColors.barDefault;
    }
  }

  bool _shouldGlow(int index) {
    final state = sortState.getBarState(index);
    return state == BarState. comparing ||
        state == BarState.swapping ||
        state == BarState.pivot;
  }

  @override
  Widget build(BuildContext context) {
    if (sortState.numbers.isEmpty) {
      return const Center(child: Text('No data'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size:  Size(constraints.maxWidth, constraints.maxHeight),
          painter: _CircularPainter(
            sortState: sortState,
            getColor: _getColor,
            shouldGlow: _shouldGlow,
          ),
        );
      },
    );
  }
}

class _CircularPainter extends CustomPainter {
  final SortState sortState;
  final Color Function(int) getColor;
  final bool Function(int) shouldGlow;

  _CircularPainter({
    required this.sortState,
    required this.getColor,
    required this.shouldGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (sortState. numbers.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 60;

    // Find max value for scaling
    final maxValue = sortState.numbers.reduce(math.max);

    // Draw circle outline
    final circlePaint = Paint()
      ..color = AppColors.surfaceLight. withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius, circlePaint);

    // Draw elements
    for (int i = 0; i < sortState.numbers.length; i++) {
      final angle = (2 * math.pi * i) / sortState.numbers.length - math.pi / 2;
      final value = sortState.numbers[i];
      
      // Calculate position on circle
      final x = center. dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      // Calculate bar length (from circle outward)
      final barLength = (value / maxValue) * 60;
      final endX = center.dx + (radius + barLength) * math.cos(angle);
      final endY = center.dy + (radius + barLength) * math.sin(angle);

      final color = getColor(i);
      final isGlowing = shouldGlow(i);

      // Draw bar
      final barPaint = Paint()
        ..color = color
        ..strokeWidth = sortState.numbers.length > 50 ? 2 : 4
        ..strokeCap = StrokeCap. round;

      if (isGlowing) {
        barPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      }

      canvas. drawLine(Offset(x, y), Offset(endX, endY), barPaint);

      // Draw dot at end
      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas. drawCircle(Offset(endX, endY), isGlowing ? 5 : 3, dotPaint);
    }

    // Draw center dot
    final centerDotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    canvas. drawCircle(center, 6, centerDotPaint);
  }

  @override
  bool shouldRepaint(_CircularPainter oldDelegate) {
    return oldDelegate.sortState != sortState;
  }
}