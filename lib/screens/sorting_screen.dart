import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_sizes.dart';
import '../core/enums/algorithm_type.dart';
import '../core/enums/visualization_type.dart';
import '../models/sort_state.dart';
import '../algorithms/base_sort_algorithm.dart';
import '../algorithms/bubble_sort.dart';
import '../algorithms/selection_sort.dart';
import '../algorithms/insertion_sort.dart';
import '../algorithms/merge_sort.dart';
import '../algorithms/quick_sort.dart';
import '../algorithms/heap_sort.dart';
import '../algorithms/radix_sort.dart';
import '../widgets/sort_bar.dart';
import '../widgets/stats_display.dart';
import '../widgets/control_panel.dart';
import '../widgets/shortcuts_handler.dart';
import '../widgets/algorithm_info_card.dart';
import '../widgets/visualization_selector.dart';
import '../widgets/visualizations/scatter_plot_visualization.dart';
import '../widgets/visualizations/circular_visualization.dart';
import '../widgets/visualizations/wave_visualization.dart';
import '../core/utils/snackbar_helper.dart';
import '../core/services/sound_manager.dart';
import '../core/services/preferences_manager.dart';
import '../core/services/achievement_manager.dart';
import '../widgets/achievement_popup.dart';

/// Sorting Screen - Main visualization screen
class SortingScreen extends StatefulWidget {
  final AlgorithmType algorithm;
  final int? initialArraySize;
  final int? initialSpeed;

  const SortingScreen({
    super.key,
    required this. algorithm,
    this.initialArraySize,
    this.initialSpeed,
  });

  @override
  State<SortingScreen> createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> {
  // ========== STATE ==========

  late SortState _sortState;
  BaseSortAlgorithm? _algorithm;

  bool _showCelebration = false;
  bool _isGenerating = false;
  bool _isInfoExpanded = false;
  bool _wasPaused = false; // ← ADD THIS

  late VisualizationType _visualizationType;

  // Services
  final _soundManager = SoundManager();
  final _prefs = PreferencesManager();
  final _achievementManager = AchievementManager(); // ← ADD THIS

  // ========== LIFECYCLE ==========

  @override
  void initState() {
    super.initState();
    _achievementManager.initialize();
    _initializeWithDefaults();
  }

  @override
  void dispose() {
    _algorithm?.stop();
    super.dispose();
  }

  // ========== INITIALIZATION ==========

  void _initializeWithDefaults() {
    final defaultArraySize = widget.initialArraySize ??  _prefs.getDefaultArraySize();
    final defaultSpeed = widget.initialSpeed ?? _prefs.getDefaultSpeed();
    _visualizationType = _prefs.getDefaultVisualization();

    _sortState = SortState.withRandomArray(
      arraySize: defaultArraySize,
      speed: defaultSpeed,
    );

    _createAlgorithm();
  }

  void _createAlgorithm() {
    switch (widget.algorithm) {
      case AlgorithmType.bubble:
        _algorithm = BubbleSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: _sortState,
        );
        break;

      case AlgorithmType.selection:
        _algorithm = SelectionSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: _sortState,
        );
        break;

      case AlgorithmType.insertion:
        _algorithm = InsertionSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: _sortState,
        );
        break;

      case AlgorithmType.merge:
        _algorithm = MergeSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: _sortState,
        );
        break;

      case AlgorithmType.quick:
        _algorithm = QuickSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: _sortState,
        );
        break;

      case AlgorithmType.heap:
        _algorithm = HeapSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: _sortState,
        );
        break;

      case AlgorithmType.radix:
        _algorithm = RadixSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState:  _sortState,
        );
        break;

      default:
        _algorithm = BubbleSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState:  _sortState,
        );
    }
  }

  // ========== CALLBACKS ==========

  void _onStateUpdate(SortState newState) {
    if (mounted) {
      final wasNotCompleted = _sortState.status != SortStatus.completed;
      final isNowCompleted = newState.status == SortStatus.completed;

      setState(() {
        _sortState = newState;
      });

      if (wasNotCompleted && isNowCompleted) {
        _trackCompletion(newState);
        _triggerCelebration();
      }

      if (newState.status == SortStatus. sorting && _showCelebration) {
        _showCelebration = false;
      }
    }
  }

  // ========== Track completion statistics ==========
  void _trackCompletion(SortState state) async {
    // Increment total sorts
    await _prefs.incrementTotalSorts();

    // Track algorithm tried
    await _achievementManager.addAlgorithmTried(widget.algorithm);

    // Check if perfect sort (no pauses)
    final isPerfectSort = ! _wasPaused;

    // Update fastest sort time
    if (state.elapsed. inMilliseconds > 0) {
      final elapsedMs = state.elapsed.inMilliseconds;
      await _prefs.updateFastestSortTime(elapsedMs);
    }

    // Check achievements
    final newAchievements = await _achievementManager.checkAchievements(
      totalSorts: _prefs.getTotalSorts(),
      fastestTime: _prefs.getFastestSortTime(),
      isPerfectSort: isPerfectSort,
    );

    // Show achievement popups
    if (mounted && newAchievements.isNotEmpty) {
      for (var achievement in newAchievements) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          AchievementPopup.show(context, achievement);
        }
      }
    }
  }

  void _triggerCelebration() {
    if (_showCelebration) return;

    _showCelebration = true;
    _soundManager.hapticHeavy();

    final messages = AppStrings.completionMessages;
    final randomMessage = messages[math.Random().nextInt(messages.length)];

    SnackBarHelper.showSuccess(context, randomMessage, icon: Icons.celebration);
  }

  // ========== ACTIONS ==========

  Future<void> _onStart() async {
    _soundManager.hapticMedium();

    if (_sortState.status == SortStatus.idle) {
      await _algorithm?.start();
    } else if (_sortState.status == SortStatus.paused) {
      _algorithm?.resume();
    }
  }

  void _onPause() {
    _soundManager.hapticLight();
    _wasPaused = true; // ← ADD THIS
    _algorithm?.pause();
  }

  void _onReset() {
    _soundManager.hapticMedium();

    setState(() {
      _isGenerating = true;
      _wasPaused = false; // ← ADD THIS
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        _sortState = _sortState.generateNewArray();
        _createAlgorithm();
        _isGenerating = false;
      });

      SnackBarHelper. showInfo(context, AppStrings.msgArrayGenerated);
    });
  }

  void _onShuffle() {
    if (_sortState.status != SortStatus.idle) return;

    _soundManager.hapticMedium();

    setState(() {
      _isGenerating = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        final shuffledNumbers = List<int>.from(_sortState.numbers).. shuffle();

        _sortState = _sortState.copyWith(
          numbers: shuffledNumbers,
          status: SortStatus.idle,
          comparisons: 0,
          swaps: 0,
          elapsed: Duration.zero,
          sortedIndices: const {},
          clearCurrentIndex: true,
          clearComparingIndex: true,
          clearPivotIndex: true,
          clearSwappingIndex: true,
        );

        _createAlgorithm();
        _isGenerating = false;
      });

      SnackBarHelper.showSecondary(
        context,
        AppStrings.msgArrayShuffled,
        icon: Icons.shuffle,
      );
    });
  }

  void _onArraySizeChanged(double value) {
    if (_sortState.status != SortStatus.idle) return;

    setState(() {
      _isGenerating = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      setState(() {
        _sortState = SortState.withRandomArray(
          arraySize: value.toInt(),
          speed: _sortState.speed,
        );
        _createAlgorithm();
        _isGenerating = false;
      });
    });
  }

  void _onSpeedChanged(double value) {
    setState(() {
      _sortState = _sortState.copyWith(speed: value. toInt());
      _algorithm = _createAlgorithmInstance(_sortState);
    });
  }

  void _onVisualizationChanged(VisualizationType newType) {
    if (_sortState.status != SortStatus.idle &&
        _sortState.status != SortStatus.completed) {
      return;
    }

    _soundManager.hapticLight();

    setState(() {
      _visualizationType = newType;

      if (_sortState.status == SortStatus.completed) {
        final shuffledNumbers = List<int>.from(_sortState.numbers)..shuffle();

        _sortState = _sortState.copyWith(
          numbers: shuffledNumbers,
          status: SortStatus.idle,
          comparisons: 0,
          swaps: 0,
          elapsed: Duration.zero,
          sortedIndices: const {},
          clearCurrentIndex: true,
          clearComparingIndex: true,
          clearPivotIndex: true,
          clearSwappingIndex: true,
        );

        _createAlgorithm();
        _showCelebration = false;
      }
    });

    SnackBarHelper.showInfo(
      context,
      'Switched to ${newType.displayName}${_sortState.status == SortStatus.completed ? " (Auto-shuffled)" : ""}',
    );
  }

  BaseSortAlgorithm _createAlgorithmInstance(SortState state) {
    switch (widget.algorithm) {
      case AlgorithmType.bubble:
        return BubbleSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: state,
        );
      case AlgorithmType.selection:
        return SelectionSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: state,
        );
      case AlgorithmType.insertion:
        return InsertionSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: state,
        );
      case AlgorithmType.merge:
        return MergeSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: state,
        );
      case AlgorithmType.quick:
        return QuickSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: state,
        );
      case AlgorithmType.heap:
        return HeapSortAlgorithm(
          onStateUpdate:  _onStateUpdate,
          initialState: state,
        );
      case AlgorithmType.radix:
        return RadixSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: state,
        );
      default:
        return BubbleSortAlgorithm(
          onStateUpdate: _onStateUpdate,
          initialState: state,
        );
    }
  }

  // ========== BUILD UI ==========
  @override
  Widget build(BuildContext context) {
    return ShortcutsHandler(
      onStart: 
          _sortState.status == SortStatus. idle ||
              _sortState.status == SortStatus.paused
          ? _onStart
          : null,
      onPause: _sortState.status == SortStatus. sorting ?  _onPause : null,
      onReset: _sortState.status != SortStatus.idle ?  _onReset : null,
      child: Scaffold(
        appBar: AppBar(
          title:  Text(widget.algorithm.displayName),
          actions: [
            // Sound toggle
            IconButton(
              icon:  Icon(
                _soundManager.soundEnabled ? Icons.volume_up :  Icons.volume_off,
              ),
              onPressed: () {
                setState(() {
                  _soundManager.setSoundEnabled(!_soundManager.soundEnabled);
                });
                SnackBarHelper.showInfo(
                  context,
                  _soundManager.soundEnabled
                      ? 'Sound enabled 🔊'
                      :  'Sound disabled 🔇',
                  icon: _soundManager.soundEnabled
                      ? Icons.volume_up
                      : Icons.volume_off,
                );
              },
              tooltip: 'Toggle Sound',
            ),

            // Haptic toggle
            IconButton(
              icon: Icon(
                _soundManager.hapticEnabled
                    ? Icons.vibration
                    : Icons.mobile_off,
              ),
              onPressed: () {
                setState(() {
                  _soundManager.setHapticEnabled(!_soundManager.hapticEnabled);
                });

                if (_soundManager.hapticEnabled) {
                  _soundManager. hapticMedium();
                }

                SnackBarHelper. showInfo(
                  context,
                  _soundManager.hapticEnabled
                      ? 'Haptic enabled 📳'
                      : 'Haptic disabled',
                  icon: _soundManager.hapticEnabled
                      ?  Icons.vibration
                      :  Icons.mobile_off,
                );
              },
              tooltip:  'Toggle Haptic',
            ),

            // Info button
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed:  _showAlgorithmInfo,
              tooltip:  'Algorithm Info',
            ),
          ],
        ),

        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.surfaceGradient. scale(0.5),
          ),
          child: SafeArea(
            child: Column(
              children: [
                StatsDisplay(sortState: _sortState),
                const SizedBox(height: AppSizes.xs),
                AlgorithmInfoCard(
                  algorithm: widget.algorithm,
                  isExpanded: _isInfoExpanded,
                  onToggle: () {
                    setState(() {
                      _isInfoExpanded = !_isInfoExpanded;
                    });
                  },
                ),
                const SizedBox(height: AppSizes.xs),
                if (! _isInfoExpanded)
                  VisualizationSelector(
                    currentType: _visualizationType,
                    onChanged: _onVisualizationChanged,
                    enabled: 
                        _sortState.status == SortStatus.idle ||
                        _sortState.status == SortStatus.completed,
                  ),
                if (! _isInfoExpanded)
                  const SizedBox(height: AppSizes.sm),
                if (! _isInfoExpanded)
                  Expanded(child: _buildVisualizationArea()),
                if (_isInfoExpanded) const Spacer(),
                ControlPanel(
                  sortState: _sortState,
                  onStart: _onStart,
                  onPause: _onPause,
                  onReset: _onReset,
                  onShuffle:  _onShuffle,
                  onArraySizeChanged: _onArraySizeChanged,
                  onSpeedChanged: _onSpeedChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== WIDGETS ==========

  Widget _buildVisualizationArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface. withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: _sortState.numbers.isEmpty
          ? _buildEmptyState()
          : _buildVisualization(),
    );
  }

  Widget _buildVisualization() {
    if (_isGenerating) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppSizes.md),
            Text(
              'Generating array...',
              style: Theme.of(context).textTheme.bodyMedium?. copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    switch (_visualizationType) {
      case VisualizationType.barChart:
        return _buildBars();
      case VisualizationType.scatterPlot:
        return ScatterPlotVisualization(sortState: _sortState);
      case VisualizationType.circular:
        return CircularVisualization(sortState:  _sortState);
      case VisualizationType.wave:
        return WaveVisualization(sortState: _sortState);
      case VisualizationType.disparity:
        return Center(
          child: Text(
            'Disparity visualization coming soon! ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        );
    }
  }

  Widget _buildBars() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final totalBars = _sortState.numbers. length;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: totalBars > 70 ? 2.0 : AppSizes.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalBars, (index) {
              return SortBar(
                value: _sortState.numbers[index],
                state: _sortState. getBarState(index),
                maxHeight: maxHeight,
                totalBars: totalBars,
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            size: AppSizes.iconXl,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            AppStrings.emptyNoData,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textDisabled,
                ),
          ),
        ],
      ),
    );
  }

  // ========== DIALOGS ==========

  void _showAlgorithmInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getAlgorithmIcon(), color: AppColors.primary),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                widget.algorithm.displayName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.algorithm.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSizes. md),
              _buildInfoRow('Time Complexity', widget.algorithm.timeComplexity),
              _buildInfoRow(
                'Space Complexity',
                widget.algorithm.spaceComplexity,
              ),
              _buildInfoRow('Stable', widget.algorithm.isStable ?  'Yes' : 'No'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?. copyWith(
                  color:  AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'JetBrains Mono',
                ),
          ),
        ],
      ),
    );
  }

  IconData _getAlgorithmIcon() {
    switch (widget.algorithm) {
      case AlgorithmType.bubble:
        return Icons.bubble_chart;
      case AlgorithmType.selection:
        return Icons.check_circle_outline;
      case AlgorithmType.insertion:
        return Icons.add_circle_outline;
      case AlgorithmType.merge:
        return Icons.merge_type;
      case AlgorithmType.quick:
        return Icons.flash_on;
      case AlgorithmType.heap:
        return Icons.account_tree;
      case AlgorithmType.radix:
        return Icons.filter_9_plus;
      case AlgorithmType.bogo:
        return Icons.shuffle;
      case AlgorithmType.stalin:
        return Icons.delete_sweep;
    }
  }
}