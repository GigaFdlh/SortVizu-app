import '../models/sort_state.dart';
import 'package:flutter/services.dart';
import '../core/services/sound_manager.dart';

/// Callback type untuk update state
typedef SortStateCallback = void Function(SortState state);

/// Abstract base class untuk semua sorting algorithms
/// Semua algorithm harus extends class ini
abstract class BaseSortAlgorithm {
  /// Callback untuk update state ke UI
  final SortStateCallback onStateUpdate;
  final _soundManager = SoundManager();

  /// Current sort state
  SortState _state;

  /// Flag untuk track jika sorting sedang berjalan
  bool _isRunning = false;

  /// Flag untuk track jika sorting di-pause
  bool _isPaused = false;

  /// Constructor
  BaseSortAlgorithm({
    required this.onStateUpdate,
    required SortState initialState,
  }) : _state = initialState;

  // ========== GETTERS ==========

  /// Get current state
  SortState get currentState => _state;

  /// Check if sorting is running
  bool get isRunning => _isRunning;

  /// Check if sorting is paused
  bool get isPaused => _isPaused;

  // ========== ABSTRACT METHODS (Must be implemented) ==========

  /// Main sorting method - MUST be implemented by subclasses
  Future<void> sort();

  /// Get algorithm name
  String get algorithmName;

  /// Get time complexity
  String get timeComplexity;

  /// Get space complexity
  String get spaceComplexity;

  // ========== CONCRETE METHODS (Shared by all algorithms) ==========

  /// Start sorting
  Future<void> start() async {
    if (_isRunning) return;

    _isRunning = true;
    _isPaused = false;

    // Update state to sorting
    _updateState(_state.copyWith(status: SortStatus.sorting));

    // Start timer
    final startTime = DateTime.now();

    // Run sorting algorithm
    await sort();

    // Calculate elapsed time
    final endTime = DateTime.now();
    final elapsed = endTime.difference(startTime);

    // Update state to completed
    if (_isRunning) {
      _soundManager.playComplete();
      _soundManager.hapticHeavy();

      _updateState(
        _state.copyWith(
          status: SortStatus.completed,
          elapsed: elapsed,
        ).markCompleted(),
      );
    }

    _isRunning = false;
  }

  /// Pause sorting
  void pause() {
    if (!_isRunning || _isPaused) return;

    _isPaused = true;
    _updateState(_state. copyWith(status: SortStatus.paused));
  }

  /// Resume sorting
  void resume() {
    if (!_isRunning || !_isPaused) return;

    _isPaused = false;
    _updateState(_state.copyWith(status: SortStatus.sorting));
  }

  /// Stop sorting (cancel)
  void stop() {
    _isRunning = false;
    _isPaused = false;
    _updateState(_state.copyWith(status: SortStatus. stopped));
  }

  /// Reset to initial state
  void reset() {
    stop();
    _updateState(_state.reset());
  }

  // ========== HELPER METHODS (For subclasses to use) ==========

  /// Update state dan notify UI
  /// Update state dan notify UI (accessible to subclasses)
  void updateState(SortState newState) {
    _state = newState;
    onStateUpdate(_state);
  }

  /// Internal wrapper untuk backward compatibility
  void _updateState(SortState newState) {
    updateState(newState);
  }

  /// Wait for pause/resume
  /// Subclasses harus panggil ini di setiap step sorting
  Future<void> waitIfPaused() async {
    while (_isPaused && _isRunning) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  /// Check if should stop (user cancelled)
  bool shouldStop() {
    return ! _isRunning;
  }

  /// Delay untuk animation (based on speed)
  Future<void> delay() async {
    if (! _isRunning) return;
    await waitIfPaused();
    if (!_isRunning) return;
    await Future.delayed(Duration(milliseconds: _state.speed));
  }

  /// Update comparison (mark two indices as comparing)
  Future<void> setComparing(int i, int j) async {
    if (!_isRunning) return;

    _updateState(
      _state.copyWith(
        currentIndex: i,
        comparingIndex: j,
      ).incrementComparisons(),
    );

    _soundManager.playComparison(_state.numbers[j]);

    await delay();
  }

  /// Swap two elements
  Future<void> swap(int i, int j) async {
    if (! _isRunning) return;
    _updateState(
      _state.copyWith(
        swappingIndex: i,
        comparingIndex: j,
      ),
    );

    HapticFeedback.selectionClick();
    
    _soundManager.playSwap();
    _soundManager.hapticSelection();

    await delay();
    _updateState(_state.swapElements(i, j));

    await delay();
    _updateState(
      _state.copyWith(
        clearSwappingIndex: true,
      ),
    );
  }

  /// Mark index as sorted
  Future<void> markSorted(int index) async {
    if (!_isRunning) return;

    _updateState(_state.markIndexAsSorted(index));
    await delay();
  }

  /// Mark range as sorted
  Future<void> markRangeSorted(int start, int end) async {
    if (!_isRunning) return;

    _updateState(_state.markRangeAsSorted(start, end));
    await delay();
  }

  /// Clear all highlighting (for new iteration)
  void clearHighlight() {
    _updateState(
      _state.copyWith(
        clearCurrentIndex: true,
        clearComparingIndex: true,
        clearPivotIndex: true,
        clearSwappingIndex: true,
      ),
    );
  }

  /// Compare two elements (returns true if arr[i] > arr[j])
  bool compare(int i, int j) {
    final numbers = _state.numbers;
    if (i < 0 || i >= numbers.length || j < 0 || j >= numbers.length) {
      return false;
    }
    return numbers[i] > numbers[j];
  }

  /// Get value at index
  int getValue(int index) {
    return _state.numbers[index];
  }

  /// Get array length
  int get length => _state.numbers.length;
}