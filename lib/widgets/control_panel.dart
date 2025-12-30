import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_strings.dart';
import '../models/sort_state.dart';

/// Control Panel Widget - Sorting controls
class ControlPanel extends StatelessWidget {
  final SortState sortState;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onShuffle;
  final ValueChanged<double> onArraySizeChanged;
  final ValueChanged<double> onSpeedChanged;

  const ControlPanel({
    super. key,
    required this.sortState,
    required this.onStart,
    required this.onPause,
    required this. onReset,
    required this.onShuffle,
    required this.onArraySizeChanged,
    required this.onSpeedChanged,
  });

  // ========== SAME AS SETTINGS SCREEN ==========
  
  /// Convert speed (ms) to slider value (1-10)
  double _msToSliderValue(int speedMs) {
    if (speedMs >= 500) return 1;
    if (speedMs >= 250) return 2;
    if (speedMs >= 150) return 3;
    if (speedMs >= 100) return 4;
    if (speedMs >= 75) return 5;
    if (speedMs >= 50) return 6;
    if (speedMs >= 30) return 7;
    if (speedMs >= 20) return 8;
    if (speedMs >= 15) return 9;
    return 10;
  }

  /// Convert slider value (1-10) to speed (ms)
  int _sliderValueToMs(double sliderValue) {
    switch (sliderValue. round()) {
      case 1: return 500;  // 0.25x
      case 2: return 250;  // 0.5x
      case 3: return 150;  // 0.75x
      case 4: return 100;  // 1x
      case 5: return 75;   // 1.5x
      case 6: return 50;   // 2x
      case 7: return 30;   // 3x
      case 8: return 20;   // 4x
      case 9: return 15;   // 5x
      case 10: return 10;  // 10x
      default: return 100;
    }
  }

  /// Get speed multiplier label
  String _getSpeedLabel(int speedMs) {
    if (speedMs >= 500) return '0.25x';
    if (speedMs >= 250) return '0.5x';
    if (speedMs >= 150) return '0.75x';
    if (speedMs >= 100) return '1x';
    if (speedMs >= 75) return '1.5x';
    if (speedMs >= 50) return '2x';
    if (speedMs >= 30) return '3x';
    if (speedMs >= 20) return '4x';
    if (speedMs >= 15) return '5x';
    return '10x';
  }

  // =============================================

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets. symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface. withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
        boxShadow:  [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors. surfaceLight. withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Primary Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  [
              _buildPrimaryButton(context),
              _buildResetButton(context),
              _buildShuffleButton(context),
            ],
          ),

          const SizedBox(height:  AppSizes.sm),

          // Array Size Slider
          _buildSlider(
            context: context,
            label: AppStrings.labelArraySize,
            value: sortState. arraySize.toDouble(),
            min: 10,
            max: 100,
            divisions:  18,
            onChanged:  sortState.status == SortStatus.idle
                ? onArraySizeChanged
                : null,
            displayValue: '${sortState.arraySize}',
          ),

          const SizedBox(height: AppSizes. xs),

          // Speed Slider (CONSISTENT WITH SETTINGS)
          _buildSlider(
            context:  context,
            label: AppStrings.labelSpeed,
            value: _msToSliderValue(sortState.speed), // ← SAME CONVERSION
            min: 1,
            max: 10,
            divisions: 9, // ← 9 divisions for 10 steps
            onChanged: (sliderValue) {
              final speedMs = _sliderValueToMs(sliderValue); // ← SAME CONVERSION
              onSpeedChanged(speedMs. toDouble());
            },
            displayValue:  _getSpeedLabel(sortState.speed), // ← SAME LABEL
            isInverted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required BuildContext context,
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double>? onChanged,
    required String displayValue,
    bool isInverted = false,
  }) {
    final isEnabled = onChanged != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment. spaceBetween,
          children:  [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isEnabled
                        ? AppColors.textPrimary
                        : AppColors.textDisabled,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Text(
                displayValue,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontFamily: 'JetBrains Mono',
                      fontWeight: FontWeight. w700,
                    ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (isInverted)
              Text(
                'Slower',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize:  10,
                    ),
              ),
            Expanded(
              child: Slider(
                value: value,
                min:  min,
                max: max,
                divisions: divisions,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.surfaceLight,
                onChanged:  onChanged,
              ),
            ),
            if (isInverted)
              Text(
                'Faster',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    final isPaused = sortState.status == SortStatus.paused;
    final isSorting = sortState.status == SortStatus.sorting;
    final isCompleted = sortState.status == SortStatus.completed;

    String buttonText;
    IconData buttonIcon;
    VoidCallback?  onPressed;

    if (isCompleted) {
      buttonText = 'Done';
      buttonIcon = Icons. check_circle;
      onPressed = null;
    } else if (isSorting) {
      buttonText = 'Pause';
      buttonIcon = Icons. pause;
      onPressed = onPause;
    } else if (isPaused) {
      buttonText = 'Resume';
      buttonIcon = Icons.play_arrow;
      onPressed = onStart;
    } else {
      buttonText = 'Start';
      buttonIcon = Icons.play_arrow;
      onPressed = onStart;
    }

    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isCompleted
              ? AppColors.success
              : (isSorting ?  AppColors.warning : AppColors. primary),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(buttonIcon, size: 28),
            const SizedBox(height: AppSizes.xs),
            Text(
              buttonText,
              style:  Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    final canReset = sortState.status != SortStatus. idle;

    return Expanded(
      child: OutlinedButton(
        onPressed: canReset ? onReset : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: canReset ? AppColors.error : AppColors.textDisabled,
          side: BorderSide(
            color: canReset ?  AppColors.error : AppColors. textDisabled,
            width:  2,
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restart_alt,
              size: 28,
              color: canReset ? AppColors.error :  AppColors.textDisabled,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Reset',
              style: Theme. of(context).textTheme.labelMedium?.copyWith(
                    color: canReset ? AppColors.error :  AppColors.textDisabled,
                    fontWeight: FontWeight. w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShuffleButton(BuildContext context) {
    final canShuffle = sortState.status == SortStatus.idle;

    return Expanded(
      child: OutlinedButton(
        onPressed: canShuffle ? onShuffle : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: canShuffle ? AppColors.secondary : AppColors.textDisabled,
          side: BorderSide(
            color: canShuffle ?  AppColors.secondary : AppColors. textDisabled,
            width:  2,
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize. min,
          children: [
            Icon(
              Icons.shuffle,
              size: 28,
              color: canShuffle ? AppColors.secondary : AppColors.textDisabled,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Shuffle',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: canShuffle ? AppColors.secondary : AppColors.textDisabled,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}