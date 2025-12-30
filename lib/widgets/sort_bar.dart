import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../models/sort_state.dart';

/// Individual Sort Bar Widget
class SortBar extends StatelessWidget {
  final int value;
  final BarState state;
  final double maxHeight;
  final int totalBars;

  const SortBar({
    super.key,
    required this.value,
    required this.state,
    required this.maxHeight,
    this.totalBars = 50,
  });

  Color get barColor {
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

  bool get shouldGlow {
    return state == BarState.comparing ||
        state == BarState.swapping ||
        state == BarState. pivot;
  }

  double get horizontalMargin {
    if (totalBars <= 20) return 2.0;
    if (totalBars <= 40) return 1.0;
    if (totalBars <= 60) return 0.5;
    if (totalBars <= 80) return 0.3;
    return 0.1;
  }

  double get borderRadius {
    if (totalBars <= 40) return AppSizes.barRadius;
    if (totalBars <= 70) return 2.0;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    // ULTIMATE SAFETY CHECKS
    if (maxHeight <= 0 || 
        value <= 0 || 
        !maxHeight.isFinite || 
        maxHeight. isNaN ||
        value > 1000) { // Sanity check on value
      return const SizedBox(width: 1, height: 1);
    }

    // Calculate height with multiple safety layers
    final safeMaxHeight = math.max(10.0, math.min(maxHeight, 10000.0));
    final ratio = (value. toDouble() / 300.0).clamp(0.0, 1.0);
    final calculatedHeight = ratio * safeMaxHeight;
    final normalizedHeight = calculatedHeight.clamp(2.0, safeMaxHeight);

    // Final safety check
    if (!normalizedHeight.isFinite || normalizedHeight. isNaN) {
      return const SizedBox(width: 1, height: 1);
    }

    return Flexible(
      fit: FlexFit.tight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutCubic,
          height: normalizedHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment. bottomCenter,
              colors: [
                barColor,
                barColor.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: shouldGlow && totalBars <= 60
                ? [
                    BoxShadow(
                      color: barColor.withValues(alpha: 0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}