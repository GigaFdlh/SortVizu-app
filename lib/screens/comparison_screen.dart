import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/enums/algorithm_type.dart';
import '../models/sort_state.dart';
import '../algorithms/base_sort_algorithm.dart';
import '../algorithms/bubble_sort.dart';
import '../algorithms/selection_sort.dart';
import '../algorithms/insertion_sort.dart';
import '../algorithms/merge_sort.dart';
import '../algorithms/quick_sort.dart';
import '../algorithms/heap_sort.dart';
import '../algorithms/radix_sort.dart';
import '../core/services/sound_manager.dart';
import '../core/services/preferences_manager.dart';
import '../core/utils/snackbar_helper.dart';

/// Comparison Screen - Side-by-side algorithm comparison
class ComparisonScreen extends StatefulWidget {
  final AlgorithmType?  algorithm1;
  final AlgorithmType? algorithm2;

  const ComparisonScreen({
    super.key,
    this.algorithm1,
    this.algorithm2,
  });

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  // ========== STATE ==========
  
  late AlgorithmType _selectedAlgo1;
  late AlgorithmType _selectedAlgo2;
  
  late SortState _sortState1;
  late SortState _sortState2;
  
  BaseSortAlgorithm? _algorithm1;
  BaseSortAlgorithm? _algorithm2;
  
  bool _isRacing = false;
  bool _raceFinished = false;
  AlgorithmType? _winner;
  
  final _soundManager = SoundManager();
  final _prefs = PreferencesManager();

  // ========== LIFECYCLE ==========

  @override
  void initState() {
    super.initState();
    _initializeComparison();
  }

  @override
  void dispose() {
    _algorithm1?.stop();
    _algorithm2?.stop();
    super.dispose();
  }

  // ========== INITIALIZATION ==========

  void _initializeComparison() {
    // Use passed algorithms or defaults
    _selectedAlgo1 = widget.algorithm1 ?? AlgorithmType.bubble;
    _selectedAlgo2 = widget.algorithm2 ??  AlgorithmType.quick;

    final defaultArraySize = _prefs.getDefaultArraySize();
    final defaultSpeed = _prefs.getDefaultSpeed();

    // Generate same array for fair comparison
    final sharedNumbers = List.generate(
      defaultArraySize,
      (i) => math.Random().nextInt(defaultArraySize * 3) + 10,
    );

    _sortState1 = SortState. initial(
      arraySize: defaultArraySize,
      speed: defaultSpeed,
    ).copyWith(numbers: List.from(sharedNumbers));

    _sortState2 = SortState.initial(
      arraySize: defaultArraySize,
      speed: defaultSpeed,
    ).copyWith(numbers: List.from(sharedNumbers));

    _createAlgorithms();
  }

  void _createAlgorithms() {
    _algorithm1 = _createAlgorithm(_selectedAlgo1, _sortState1, true);
    _algorithm2 = _createAlgorithm(_selectedAlgo2, _sortState2, false);
  }

  BaseSortAlgorithm _createAlgorithm(
    AlgorithmType type,
    SortState state,
    bool isLeft,
  ) {
    void onUpdate(SortState newState) {
      if (mounted) {
        setState(() {
          if (isLeft) {
            _sortState1 = newState;
          } else {
            _sortState2 = newState;
          }

          // Check if race finished
          if (_isRacing && ! _raceFinished) {
            _checkRaceFinished();
          }
        });
      }
    }

    switch (type) {
      case AlgorithmType.bubble:
        return BubbleSortAlgorithm(
          onStateUpdate: onUpdate,
          initialState: state,
        );
      case AlgorithmType.selection:
        return SelectionSortAlgorithm(
          onStateUpdate: onUpdate,
          initialState: state,
        );
      case AlgorithmType. insertion:
        return InsertionSortAlgorithm(
          onStateUpdate: onUpdate,
          initialState: state,
        );
      case AlgorithmType.merge:
        return MergeSortAlgorithm(
          onStateUpdate: onUpdate,
          initialState: state,
        );
      case AlgorithmType.quick:
        return QuickSortAlgorithm(
          onStateUpdate: onUpdate,
          initialState: state,
        );
      case AlgorithmType.heap:
        return HeapSortAlgorithm(
          onStateUpdate:  onUpdate,
          initialState:  state,
        );
      case AlgorithmType.radix:
        return RadixSortAlgorithm(
          onStateUpdate: onUpdate,
          initialState: state,
        );
      default:
        return BubbleSortAlgorithm(
          onStateUpdate: onUpdate,
          initialState: state,
        );
    }
  }

  // ========== RACE LOGIC ==========

  void _checkRaceFinished() {
    final both1Finished = _sortState1.status == SortStatus. completed;
    final both2Finished = _sortState2.status == SortStatus.completed;

    if (both1Finished && both2Finished && ! _raceFinished) {
      _raceFinished = true;

      // Determine winner
      final time1 = _sortState1.elapsed. inMilliseconds;
      final time2 = _sortState2.elapsed.inMilliseconds;

      if (time1 < time2) {
        _winner = _selectedAlgo1;
      } else if (time2 < time1) {
        _winner = _selectedAlgo2;
      } else {
        _winner = null; // Tie
      }

      _soundManager.playComplete();
      _soundManager.hapticHeavy();

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showWinnerDialog();
        }
      });
    }
  }

  // ========== ACTIONS ==========

  Future<void> _startRace() async {
    if (_isRacing) return;

    _soundManager.hapticMedium();

    setState(() {
      _isRacing = true;
      _raceFinished = false;
      _winner = null;
    });

    // Start both algorithms simultaneously
    _algorithm1?.start();
    _algorithm2?.start();
  }

  void _pauseRace() {
    _soundManager.hapticLight();
    _algorithm1?.pause();
    _algorithm2?.pause();
  }

  void _resumeRace() {
    _soundManager.hapticMedium();
    _algorithm1?.resume();
    _algorithm2?.resume();
  }

  void _resetRace() {
    _soundManager.hapticMedium();

    _algorithm1?.stop();
    _algorithm2?.stop();

    setState(() {
      _isRacing = false;
      _raceFinished = false;
      _winner = null;
    });

    _initializeComparison();

    SnackBarHelper.showInfo(context, 'Race reset with new array');
  }

  void _changeAlgorithm(bool isLeft, AlgorithmType newAlgo) {
    if (_isRacing) return;

    _soundManager.hapticLight();

    setState(() {
      if (isLeft) {
        _selectedAlgo1 = newAlgo;
      } else {
        _selectedAlgo2 = newAlgo;
      }
      _createAlgorithms();
    });
  }

  // ========== BUILD UI ==========

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algorithm Battle ⚔️'),
        actions: [
          IconButton(
            icon: Icon(
              _soundManager.soundEnabled
                  ? Icons.volume_up
                  : Icons.volume_off,
            ),
            onPressed: () {
              setState(() {
                _soundManager. setSoundEnabled(!_soundManager.soundEnabled);
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.surfaceGradient. scale(0.5),
        ),
        child: Column(
          children: [
            // Algorithm Selectors
            _buildAlgorithmSelectors(),

            // Divider
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(vertical: AppSizes.sm),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors. primary.withValues(alpha: 0.5),
                    AppColors.secondary.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),

            // Stats Row
            _buildStatsRow(),

            const SizedBox(height: AppSizes.md),

            // Visualization Area (Split)
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildVisualizationPanel(_sortState1, true)),
                  Container(
                    width: 2,
                    color: AppColors.surfaceLight. withValues(alpha: 0.3),
                  ),
                  Expanded(child: _buildVisualizationPanel(_sortState2, false)),
                ],
              ),
            ),

            // Control Panel
            _buildControlPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlgorithmSelectors() {
    return Container(
      padding: const EdgeInsets.all(AppSizes. md),
      child: Row(
        children: [
          Expanded(
            child: _buildAlgorithmDropdown(_selectedAlgo1, true),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
            child: Icon(
              Icons.compare_arrows,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          Expanded(
            child: _buildAlgorithmDropdown(_selectedAlgo2, false),
          ),
        ],
      ),
    );
  }

  Widget _buildAlgorithmDropdown(AlgorithmType selected, bool isLeft) {
    final availableAlgorithms = [
      ... getBasicAlgorithms(),
      ...getAdvancedAlgorithms(),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: isLeft
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: isLeft
              ? AppColors.primary. withValues(alpha: 0.3)
              : AppColors. secondary.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButton<AlgorithmType>(
        value: selected,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AppColors.surface,
        icon: Icon(
          Icons.arrow_drop_down,
          color: isLeft ? AppColors.primary : AppColors.secondary,
        ),
        items: availableAlgorithms.map((algo) {
          return DropdownMenuItem(
            value: algo,
            child: Text(
              algo.displayName,
              style: TextStyle(
                color: isLeft ?  AppColors.primary : AppColors. secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
        onChanged: _isRacing
            ? null
            : (value) {
                if (value != null) {
                  _changeAlgorithm(isLeft, value);
                }
              },
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: [
          Expanded(child: _buildStatsCard(_sortState1, true)),
          const SizedBox(width: AppSizes.sm),
          Expanded(child:  _buildStatsCard(_sortState2, false)),
        ],
      ),
    );
  }

  Widget _buildStatsCard(SortState state, bool isLeft) {
    final color = isLeft ? AppColors.primary : AppColors.secondary;

    return Container(
      padding: const EdgeInsets.all(AppSizes. sm),
      decoration: BoxDecoration(
        color: color. withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes. radiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Comps', '${state.comparisons}', color),
              _buildStatItem('Swaps', '${state.swaps}', color),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          _buildStatItem(
            'Time',
            state.elapsed.inMilliseconds > 0
                ? '${(state.elapsed.inMilliseconds / 1000).toStringAsFixed(2)}s'
                : '0.00s',
            color,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'JetBrains Mono',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color. withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildVisualizationPanel(SortState state, bool isLeft) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.surface. withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _buildBars(state, constraints. maxHeight, isLeft);
        },
      ),
    );
  }

  Widget _buildBars(SortState state, double maxHeight, bool isLeft) {
    final totalBars = state.numbers.length;
    final color = isLeft ? AppColors.primary : AppColors.secondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalBars, (index) {
        final barState = state.getBarState(index);
        Color barColor;

        switch (barState) {
          case BarState. sorted:
            barColor = AppColors.success;
            break;
          case BarState.comparing:
            barColor = AppColors.warning;
            break;
          case BarState.swapping:
            barColor = AppColors.error;
            break;
          case BarState.pivot:
            barColor = AppColors.info;
            break;
          default:
            barColor = color;
        }

        return Container(
          width: totalBars > 50 ? 3 : 6,
          height: (state.numbers[index] / (state.arraySize * 3)) * maxHeight,
          margin: EdgeInsets.symmetric(horizontal: totalBars > 50 ? 0.5 : 1),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius. circular(2),
          ),
        );
      }),
    );
  }

  Widget _buildControlPanel() {
    final canStart = ! _isRacing;
    final canPause = _isRacing &&
        (_sortState1.status == SortStatus.sorting ||
            _sortState2.status == SortStatus. sorting);
    final canResume = _isRacing &&
        (_sortState1.status == SortStatus.paused ||
            _sortState2.status == SortStatus.paused);

    return Container(
      padding:  const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
        boxShadow: [
          BoxShadow(
            color:  Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Start/Resume Button
          Expanded(
            child: ElevatedButton. icon(
              onPressed: canStart
                  ? _startRace
                  : (canResume ? _resumeRace :  null),
              icon: Icon(canStart ? Icons.play_arrow : Icons.play_arrow),
              label: Text(canStart ? 'Start Race' : 'Resume'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(AppSizes.md),
              ),
            ),
          ),

          const SizedBox(width: AppSizes.sm),

          // Pause Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: canPause ? _pauseRace : null,
              icon: const Icon(Icons.pause),
              label: const Text('Pause'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors. warning,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(AppSizes.md),
              ),
            ),
          ),

          const SizedBox(width: AppSizes.sm),

          // Reset Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _resetRace,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset'),
              style:  OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error, width: 2),
                padding: const EdgeInsets.all(AppSizes.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== DIALOGS ==========

  void _showWinnerDialog() {
    String title;
    String message;
    IconData icon;

    if (_winner == null) {
      title = "It's a Tie!  🤝";
      message = 'Both algorithms finished at the same time!';
      icon = Icons.handshake;
    } else {
      final winnerName = _winner?.displayName;
      final loser = _winner == _selectedAlgo1 ? _selectedAlgo2 : _selectedAlgo1;
      
      final winnerTime = _winner == _selectedAlgo1
          ?  _sortState1.elapsed.inMilliseconds
          : _sortState2.elapsed.inMilliseconds;
      final loserTime = _winner == _selectedAlgo1
          ? _sortState2.elapsed.inMilliseconds
          : _sortState1.elapsed.inMilliseconds;

      final diff = ((loserTime - winnerTime) / 1000).toStringAsFixed(2);

      title = '$winnerName Wins! 🏆';
      message = 'Finished ${diff}s faster than ${loser. displayName}!';
      icon = Icons.emoji_events;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(width: AppSizes.sm),
            Expanded(child: Text(title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: AppSizes.md),
            _buildFinalStats(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetRace();
            },
            child: const Text('Race Again'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalStats() {
    return Container(
      padding: const EdgeInsets. all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors. surfaceLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Column(
        children: [
          _buildFinalStatRow(
            _selectedAlgo1.displayName,
            _sortState1,
            AppColors.primary,
          ),
          const Divider(height: AppSizes.sm),
          _buildFinalStatRow(
            _selectedAlgo2.displayName,
            _sortState2,
            AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildFinalStatRow(String name, SortState state, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  [
        Text(
          name,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${(state.elapsed.inMilliseconds / 1000).toStringAsFixed(2)}s',
          style: TextStyle(
            color: color,
            fontFamily: 'JetBrains Mono',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}