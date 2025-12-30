import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/app_colors.dart';
import '../../models/sort_state.dart';

/// Wave Visualization - Smooth curve through points
class WaveVisualization extends StatelessWidget {
  final SortState sortState;

  const WaveVisualization({
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
      case BarState. selected:
        return AppColors. secondary;
      case BarState.normal:
        return AppColors.barDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sortState.numbers.isEmpty) {
      return const Center(child: Text('No data'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _WavePainter(
            sortState: sortState,
            getColor: _getColor,
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final SortState sortState;
  final Color Function(int) getColor;

  _WavePainter({
    required this.sortState,
    required this.getColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (sortState.numbers.isEmpty) return;

    final padding = 40.0;
    final plotWidth = size.width - (padding * 2);
    final plotHeight = size.height - (padding * 2);

    // Find min/max
    final maxValue = sortState. numbers.reduce(math.max);
    final minValue = sortState.numbers.reduce(math.min);
    final valueRange = maxValue - minValue;

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < sortState.numbers.length; i++) {
      final value = sortState.numbers[i];
      final x = padding + (i / (sortState.numbers.length - 1)) * plotWidth;
      final y = padding + plotHeight - 
          ((value - minValue) / valueRange) * plotHeight;
      points.add(Offset(x, y));
    }

    // Draw smooth curve
    _drawSmoothCurve(canvas, points);

    // Draw points
    for (int i = 0; i < points.length; i++) {
      _drawPoint(canvas, points[i], i);
    }
  }

  void _drawSmoothCurve(Canvas canvas, List<Offset> points) {
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points. first.dx, points.first. dy);

    // Create smooth curve using quadratic bezier
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      
      final controlPointX = (p0.dx + p1.dx) / 2;
      final controlPointY = (p0.dy + p1.dy) / 2;
      
      path.quadraticBezierTo(
        p0.dx,
        p0.dy,
        controlPointX,
        controlPointY,
      );
    }

    path.lineTo(points.last. dx, points.last.dy);

    // Draw gradient fill
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.3),
          AppColors. primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, canvas.getLocalClipBounds().width, canvas.getLocalClipBounds().height))
      ..style = PaintingStyle.fill;

    // Close path for fill
    final fillPath = Path. from(path);
    fillPath.lineTo(points.last.dx, canvas.getLocalClipBounds().bottom);
    fillPath.lineTo(points.first.dx, canvas.getLocalClipBounds().bottom);
    fillPath.close();

    canvas.drawPath(fillPath, gradientPaint);

    // Draw line
    final linePaint = Paint()
      ..color = AppColors. primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  void _drawPoint(Canvas canvas, Offset position, int index) {
    final color = getColor(index);
    final state = sortState.getBarState(index);
    
    final isActive = state == BarState.comparing ||
        state == BarState.swapping ||
        state == BarState.pivot;

    // Draw glow
    if (isActive) {
      final glowPaint = Paint()
        ..color = color. withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(position, 8, glowPaint);
    }

    // Draw point
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, isActive ? 6 : 4, pointPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white. withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      .. strokeWidth = 2;

    canvas.drawCircle(position, isActive ? 6 : 4, borderPaint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) {
    return oldDelegate.sortState != sortState;
  }
}