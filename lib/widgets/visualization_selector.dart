import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/enums/visualization_type.dart';

/// Visualization Type Selector
class VisualizationSelector extends StatelessWidget {
  final VisualizationType currentType;
  final ValueChanged<VisualizationType> onChanged;
  final bool enabled;

  const VisualizationSelector({
    super. key,
    required this.currentType,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Only show available visualizations
    final availableTypes = getAvailableVisualizations();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes. sm),
      decoration: BoxDecoration(
        color: AppColors. surface. withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:  availableTypes.map((type) {
          final isSelected = type == currentType;
          
          return Expanded(
            child: _buildTypeButton(type, isSelected),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTypeButton(VisualizationType type, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
      child: Material(
        color: isSelected
            ? AppColors.primary. withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: InkWell(
          onTap: enabled ? () => onChanged(type) : null,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.sm,
              horizontal: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(
                      color: AppColors.primary,
                      width: 2,
                    )
                  :  null,
              borderRadius: BorderRadius.circular(AppSizes. radiusSm),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Use emoji for visual representation
                Text(
                  type.previewEmoji,
                  style: const TextStyle(
                    fontSize:  20,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  type.displayName,
                  style: TextStyle(
                    color: enabled
                        ? (isSelected ? AppColors.primary :  AppColors.textSecondary)
                        :  AppColors.textDisabled,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}