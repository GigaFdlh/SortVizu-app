import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/enums/algorithm_type.dart';

/// Algorithm Info Card - Expandable with content
class AlgorithmInfoCard extends StatelessWidget {
  final AlgorithmType algorithm;
  final bool isExpanded;
  final VoidCallback onToggle;

  const AlgorithmInfoCard({
    super.key,
    required this.algorithm,
    required this. isExpanded,
    required this.onToggle,
  });

  String get detailedExplanation {
    switch (algorithm) {
      case AlgorithmType.bubble:
        return 'Repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order.  Larger elements "bubble" to the end. ';
      case AlgorithmType.selection:
        return 'Divides list into sorted/unsorted regions. Repeatedly finds minimum from unsorted region and moves it to sorted region.';
      case AlgorithmType.insertion:
        return 'Builds sorted array one item at a time. Takes each element and inserts it into correct position in already sorted portion.';
      case AlgorithmType.merge:
        return 'Divides array into halves, recursively sorts them, then merges sorted halves.  Uses divide-and-conquer strategy.';
      case AlgorithmType.quick:
        return 'Selects pivot, partitions array around it.  Elements smaller go left, larger go right. Recursively sorts partitions.';
      case AlgorithmType.heap:
        return 'Builds max heap, repeatedly extracts maximum and rebuilds heap. In-place sorting with guaranteed O(n log n).';
      case AlgorithmType.radix:
        return 'Non-comparison sort that processes digits from least to most significant using counting sort as subroutine.';
      case AlgorithmType.bogo:
        return 'Randomly shuffles and checks if sorted. Repeats until sorted.  Absurdly inefficient!  Educational only.';
      case AlgorithmType.stalin:
        return 'Removes out-of-order elements instead of sorting. Not a real sorting algorithm - just a meme! ';
    }
  }

  String get bestUseCases {
    switch (algorithm) {
      case AlgorithmType.bubble:
        return '• Small datasets\n• Nearly sorted data\n• Educational purposes';
      case AlgorithmType. selection:
        return '• Small datasets\n• Memory writes expensive\n• Simple implementation';
      case AlgorithmType.insertion:
        return '• Small-medium datasets\n• Nearly sorted data\n• Online sorting';
      case AlgorithmType. merge:
        return '• Large datasets\n• Stable sort required\n• External sorting';
      case AlgorithmType.quick:
        return '• Large datasets\n• Average case matters\n• General purpose';
      case AlgorithmType.heap:
        return '• Large datasets\n• Worst-case O(n log n)\n• Priority queues';
      case AlgorithmType.radix:
        return '• Integer sorting\n• Fixed-length keys\n• Large datasets';
      case AlgorithmType.bogo:
        return '• Never in production!\n• Comedy only';
      case AlgorithmType.stalin:
        return '• Not real sorting!\n• Meme purposes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface. withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes. radiusMd),
        border: Border.all(
          color: isExpanded
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.3),
          width: isExpanded ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (always visible)
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child:  Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: AppSizes. iconMd,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment. start,
                      children: [
                        Text(
                          algorithm.displayName,
                          style: Theme.of(context).textTheme.titleSmall?. copyWith(
                                color:  AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          algorithm.timeComplexity,
                          style:  Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.primary,
                                fontFamily: 'JetBrains Mono',
                              ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons. expand_more,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Container(
                    constraints: const BoxConstraints(
                      maxHeight: 400, // Max height
                    ),
                    child:  SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.md,
                        0,
                        AppSizes. md,
                        AppSizes.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(height: 1),
                          const SizedBox(height: AppSizes.md),

                          // Chips
                          Wrap(
                            spacing:  AppSizes.sm,
                            runSpacing: AppSizes.xs,
                            children: [
                              _buildChip(
                                context,
                                'Time:  ${algorithm.timeComplexity}',
                                Icons.schedule,
                                AppColors.info,
                              ),
                              _buildChip(
                                context,
                                'Space:  ${algorithm.spaceComplexity}',
                                Icons.storage,
                                AppColors.warning,
                              ),
                              _buildChip(
                                context,
                                algorithm.isStable ? 'Stable' : 'Unstable',
                                algorithm.isStable ? Icons.check_circle : Icons.cancel,
                                algorithm.isStable ? AppColors. success : AppColors.error,
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSizes.md),

                          // How it works
                          _buildSection(
                            context,
                            'How It Works',
                            Icons.lightbulb_outline,
                            detailedExplanation,
                          ),

                          const SizedBox(height: AppSizes. md),

                          // Best uses
                          _buildSection(
                            context,
                            'Best Used For',
                            Icons.check_box_outlined,
                            bestUseCases,
                          ),

                          const SizedBox(height: AppSizes.xs),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: AppSizes.xs),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight:  FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes. xs),
        Text(
          content,
          style: Theme. of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border. all(
          color: color. withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppSizes.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontFamily: 'JetBrains Mono',
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}