import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_strings.dart';
import '../models/sort_state.dart';

/// Stats Display Widget - Shows sorting statistics
class StatsDisplay extends StatelessWidget {
  final SortState sortState;

  const StatsDisplay({
    super.key,
    required this.sortState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      padding: const EdgeInsets. all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons. compare_arrows,
            label: AppStrings.labelComparisons,
            value: sortState.comparisons. toString(),
            color: AppColors.info,
          ),
          _StatItem(
            icon: Icons. swap_horiz,
            label: AppStrings.labelSwaps,
            value: sortState.swaps. toString(),
            color: AppColors.warning,
          ),
          _StatItem(
            icon: Icons. timer_outlined,
            label: AppStrings.labelTime,
            value: '${sortState.elapsedSeconds}s',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

/// Individual Stat Item
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this. value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size:  AppSizes.iconMd,
          color: color,
        ),
        const SizedBox(width: AppSizes.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'JetBrains Mono',
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}