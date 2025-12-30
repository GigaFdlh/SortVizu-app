import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/app_colors.dart';
import '../../models/sort_state.dart';

/// Scatter Plot Visualization - Dots in 2D space
class ScatterPlotVisualization extends StatelessWidget {
  final SortState sortState;

  const ScatterPlotVisualization({
    super.key,
    required this.sortState,
  });

  Color _getDotColor(int index) {
    final state = sortState.getBarState(index);
    
    switch (state) {
      case BarState.comparing:
        return AppColors.barComparing;
      case BarState. swapping:
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
    return state == BarState.comparing ||
        state == BarState.swapping ||
        state == BarState.pivot;
  }

  @override
  Widget build(BuildContext context) {
    // SAFETY:  Check if data is valid
    if (sortState.numbers.isEmpty || sortState.numbers.length < 2) {
      return const Center(
        child: Text('Need at least 2 elements'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // SAFETY: Check constraints
        if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
          return const SizedBox.shrink();
        }

        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ScatterPlotPainter(
            sortState: sortState,
            getDotColor: _getDotColor,
            shouldGlow: _shouldGlow,
            padding: 40.0,
          ),
        );
      },
    );
  }
}

class _ScatterPlotPainter extends CustomPainter {
  final SortState sortState;
  final Color Function(int) getDotColor;
  final bool Function(int) shouldGlow;
  final double padding;

  _ScatterPlotPainter({
    required this.sortState,
    required this.getDotColor,
    required this.shouldGlow,
    required this.padding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // SAFETY CHECKS
    if (sortState.numbers.isEmpty || 
        sortState.numbers.length < 2 ||
        size.width <= 0 || 
        size.height <= 0) {
      return;
    }

    final plotWidth = (size.width - (padding * 2)).clamp(10.0, size.width);
    final plotHeight = (size.height - (padding * 2)).clamp(10.0, size.height);

    // Find min and max values
    final maxValue = sortState.numbers.reduce(math.max);
    final minValue = sortState.numbers. reduce(math.min);
    final valueRange = (maxValue - minValue).toDouble();

    // SAFETY: Prevent division by zero
    if (valueRange <= 0) return;

    _drawAxes(canvas, size);
    _drawGrid(canvas, size, plotWidth, plotHeight);

    if (sortState.numbers.length <= 50) {
      _drawConnectionLines(canvas, plotWidth, plotHeight, valueRange, minValue);
    }

    // Draw dots
    for (int i = 0; i < sortState.numbers.length; i++) {
      final value = sortState.numbers[i];
      
      // SAFETY: Check array bounds
      if (sortState.numbers.length <= 1) continue;
      
      final x = padding + (i / (sortState.numbers.length - 1)) * plotWidth;
      final y = padding + plotHeight - 
          ((value - minValue) / valueRange) * plotHeight;

      // SAFETY: Ensure valid coordinates
      if (x. isFinite && y.isFinite && x >= 0 && y >= 0) {
        _drawDot(canvas, Offset(x, y), i);
      }
    }
  }

  void _drawAxes(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surfaceLight
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding, size.height - padding),
      paint,
    );

    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(size.width - padding, size.height - padding),
      paint,
    );
  }

  void _drawGrid(Canvas canvas, Size size, double plotWidth, double plotHeight) {
    final paint = Paint()
      ..color = AppColors.surfaceLight. withValues(alpha: 0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
      final y = padding + (plotHeight / 5) * i;
      canvas.drawLine(
        Offset(padding, y),
        Offset(padding + plotWidth, y),
        paint,
      );
    }

    for (int i = 0; i <= 10; i++) {
      final x = padding + (plotWidth / 10) * i;
      canvas.drawLine(
        Offset(x, padding),
        Offset(x, padding + plotHeight),
        paint,
      );
    }
  }

  void _drawConnectionLines(
    Canvas canvas,
    double plotWidth,
    double plotHeight,
    double valueRange,
    int minValue,
  ) {
    // SAFETY: Check all values
    if (sortState.numbers.length <= 1 || 
        valueRange <= 0 || 
        ! plotWidth.isFinite || 
        ! plotHeight.isFinite ||
        plotWidth <= 0 ||
        plotHeight <= 0) {
      return;
    }

    final paint = Paint()
      ..color = AppColors.primary. withValues(alpha: 0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool hasMovedTo = false;
    
    for (int i = 0; i < sortState. numbers.length; i++) {
      final value = sortState.numbers[i];
      final x = padding + (i / (sortState.numbers.length - 1)) * plotWidth;
      final y = padding + plotHeight - 
          ((value - minValue) / valueRange) * plotHeight;

      // SAFETY: Check coordinates
      if (x. isFinite && y.isFinite && x >= 0 && y >= 0 && 
          x <= padding + plotWidth && y <= padding + plotHeight) {
        if (!hasMovedTo) {
          path.moveTo(x, y);
          hasMovedTo = true;
        } else {
          path.lineTo(x, y);
        }
      }
    }

    if (hasMovedTo) {
      canvas.drawPath(path, paint);
    }
  }

  void _drawDot(Canvas canvas, Offset position, int index) {
    final color = getDotColor(index);
    final isGlowing = shouldGlow(index);

    if (isGlowing) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawCircle(position, 8, glowPaint);
    }

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, isGlowing ? 6 : 4, dotPaint);

    final borderPaint = Paint()
      ..color = color. withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(position, isGlowing ? 6 : 4, borderPaint);
  }

  @override
  bool shouldRepaint(_ScatterPlotPainter oldDelegate) {
    return oldDelegate.sortState != sortState;
  }
}