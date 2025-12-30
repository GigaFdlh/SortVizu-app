/// Enum untuk status sorting
enum SortStatus {
  /// Idle - belum mulai, siap untuk sort
  idle,
  
  /// Sorting - sedang proses sorting
  sorting,
  
  /// Paused - sorting di-pause user
  paused,
  
  /// Completed - sorting selesai
  completed,
  stopped,
}

enum BarState {
  normal,
  comparing,
  swapping,
  sorted,
  pivot,
  selected,
}

/// Model untuk menyimpan state sorting
class SortState {
  /// List angka yang akan di-sort
  final List<int> numbers;
  
  /// Index yang sedang diproses (i dalam loop)
  final int? currentIndex;
  
  /// Index yang sedang dibandingkan (j dalam loop)
  final int? comparingIndex;
  
  /// Index pivot (untuk Quick Sort)
  final int? pivotIndex;
  
  /// Index yang sedang di-swap
  final int? swappingIndex;
  
  /// Status sorting (idle, sorting, paused, completed)
  final SortStatus status;
  
  /// Jumlah perbandingan (comparisons) yang dilakukan
  final int comparisons;
  
  /// Jumlah pertukaran (swaps) yang dilakukan
  final int swaps;
  
  /// Waktu yang sudah elapsed (dalam milliseconds)
  final Duration elapsed;
  
  /// Set of indices yang sudah sorted (untuk highlight)
  final Set<int> sortedIndices;
  
  /// Array size (jumlah elemen)
  final int arraySize;
  
  /// Animation speed (dalam milliseconds per operation)
  final int speed;

  /// Constructor
  const SortState({
    required this.numbers,
    this.currentIndex,
    this.comparingIndex,
    this.pivotIndex,
    this.swappingIndex,
    this.status = SortStatus.idle,
    this.comparisons = 0,
    this.swaps = 0,
    this.elapsed = Duration.zero,
    this. sortedIndices = const {},
    required this.arraySize,
    this.speed = 50,
  });

  /// Factory constructor untuk create initial state
  factory SortState.initial({
    int arraySize = 50,
    int speed = 50,
  }) {
    return SortState(
      numbers:  [],
      arraySize: arraySize,
      speed: speed,
      status: SortStatus.idle,
      sortedIndices: const {},
    );
  }

  /// Factory constructor untuk generate random array
  factory SortState.withRandomArray({
    required int arraySize,
    int speed = 50,
    int minValue = 10,
    int maxValue = 300,
  }) {
    final random = List. generate(
      arraySize,
      (index) => minValue + (maxValue - minValue) * index ~/ arraySize,
    ).. shuffle();

    return SortState(
      numbers: random,
      arraySize: arraySize,
      speed:  speed,
      status: SortStatus.idle,
      sortedIndices: const {},
    );
  }

  // ========== COPYWIDTH METHOD (for immutable updates) ==========
  SortState copyWith({
    List<int>? numbers,
    int? currentIndex,
    int? comparingIndex,
    int? pivotIndex,
    int? swappingIndex,
    SortStatus? status,
    int? comparisons,
    int? swaps,
    Duration? elapsed,
    Set<int>? sortedIndices,
    int? arraySize,
    int? speed,
    bool clearCurrentIndex = false,
    bool clearComparingIndex = false,
    bool clearPivotIndex = false,
    bool clearSwappingIndex = false,
  }) {
    return SortState(
      numbers: numbers ??  this.numbers,
      currentIndex: clearCurrentIndex ? null : (currentIndex ?? this.currentIndex),
      comparingIndex: clearComparingIndex ? null : (comparingIndex ?? this.comparingIndex),
      pivotIndex: clearPivotIndex ? null : (pivotIndex ?? this.pivotIndex),
      swappingIndex: clearSwappingIndex ? null : (swappingIndex ?? this.swappingIndex),
      status: status ?? this.status,
      comparisons: comparisons ??  this.comparisons,
      swaps: swaps ?? this.swaps,
      elapsed: elapsed ??  this.elapsed,
      sortedIndices: sortedIndices ??  this.sortedIndices,
      arraySize: arraySize ?? this.arraySize,
      speed: speed ?? this.speed,
    );
  }

  // ========== HELPER METHODS ==========
  
  /// Check if sorting is active (not idle, completed, or stopped)
  bool get isActive {
    return status == SortStatus.sorting;
  }

  /// Check if sorting can be started
  bool get canStart {
    return status == SortStatus. idle || status == SortStatus. paused;
  }

  /// Check if sorting can be paused
  bool get canPause {
    return status == SortStatus.sorting;
  }

  /// Check if sorting can be resumed
  bool get canResume {
    return status == SortStatus.paused;
  }

  /// Check if sorting can be reset
  bool get canReset {
    return status != SortStatus.idle;
  }

  /// Get bar state untuk index tertentu
  BarState getBarState(int index) {
    // Priority order (highest to lowest):
    
    // 1. Swapping state (highest priority)
    if (swappingIndex == index || 
        (comparingIndex == index && swappingIndex != null)) {
      return BarState. swapping;
    }

    // 2. Pivot (untuk Quick Sort)
    if (pivotIndex == index) {
      return BarState. pivot;
    }

    // 3. Comparing
    if (currentIndex == index || comparingIndex == index) {
      return BarState.comparing;
    }

    // 4. Sorted
    if (sortedIndices.contains(index)) {
      return BarState.sorted;
    }

    // 5. Completed (semua sorted)
    if (status == SortStatus.completed) {
      return BarState.sorted;
    }

    // 6. Default - normal
    return BarState.normal;
  }

  /// Get progress (0.0 - 1.0)
  double get progress {
    if (numbers.isEmpty) return 0.0;
    if (status == SortStatus.completed) return 1.0;
    
    // Estimasi based on sorted indices
    return sortedIndices.length / numbers.length;
  }

  /// Get elapsed time in seconds (formatted)
  String get elapsedSeconds {
    final seconds = elapsed.inMilliseconds / 1000;
    return seconds.toStringAsFixed(2);
  }

  /// Generate new random array (keep size & speed)
  SortState generateNewArray({
    int minValue = 10,
    int maxValue = 300,
  }) {
    final random = List.generate(
      arraySize,
      (index) => minValue + (maxValue - minValue) * index ~/ arraySize,
    )..shuffle();

    return copyWith(
      numbers: random,
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
  }

  /// Reset state (clear stats tapi keep array)
  SortState reset() {
    return copyWith(
      status: SortStatus.idle,
      comparisons: 0,
      swaps: 0,
      elapsed: Duration.zero,
      sortedIndices: const {},
      clearCurrentIndex: true,
      clearComparingIndex:  true,
      clearPivotIndex: true,
      clearSwappingIndex: true,
    );
  }

  /// Mark sorting as completed
  SortState markCompleted() {
    return copyWith(
      status: SortStatus.completed,
      sortedIndices: Set.from(List.generate(numbers.length, (i) => i)),
      clearCurrentIndex: true,
      clearComparingIndex: true,
      clearPivotIndex:  true,
      clearSwappingIndex: true,
    );
  }

  /// Increment comparisons counter
  SortState incrementComparisons() {
    return copyWith(comparisons: comparisons + 1);
  }

  /// Increment swaps counter
  SortState incrementSwaps() {
    return copyWith(swaps: swaps + 1);
  }

  /// Update elapsed time
  SortState updateElapsed(Duration newElapsed) {
    return copyWith(elapsed: newElapsed);
  }

  /// Swap two elements in array
  SortState swapElements(int i, int j) {
    final newNumbers = List<int>.from(numbers);
    final temp = newNumbers[i];
    newNumbers[i] = newNumbers[j];
    newNumbers[j] = temp;

    return copyWith(
      numbers: newNumbers,
      swaps: swaps + 1,
    );
  }

  /// Mark index as sorted
  SortState markIndexAsSorted(int index) {
    final newSortedIndices = Set<int>.from(sortedIndices);
    newSortedIndices.add(index);

    return copyWith(sortedIndices: newSortedIndices);
  }

  /// Mark range as sorted
  SortState markRangeAsSorted(int start, int end) {
    final newSortedIndices = Set<int>.from(sortedIndices);
    for (int i = start; i <= end; i++) {
      newSortedIndices.add(i);
    }

    return copyWith(sortedIndices:  newSortedIndices);
  }

  // ========== DEBUG & LOGGING ==========
  
  @override
  String toString() {
    return 'SortState(\n'
        '  status: $status,\n'
        '  arraySize: $arraySize,\n'
        '  comparisons: $comparisons,\n'
        '  swaps:  $swaps,\n'
        '  elapsed: ${elapsedSeconds}s,\n'
        '  progress: ${(progress * 100).toStringAsFixed(1)}%,\n'
        '  currentIndex: $currentIndex,\n'
        '  comparingIndex: $comparingIndex,\n'
        ')';
  }

  /// Check if array is sorted (for validation)
  bool get isSorted {
    if (numbers.isEmpty || numbers.length == 1) return true;
    
    for (int i = 0; i < numbers.length - 1; i++) {
      if (numbers[i] > numbers[i + 1]) {
        return false;
      }
    }
    return true;
  }

  /// Get statistics as map (for display)
  Map<String, dynamic> get statistics {
    return {
      'comparisons': comparisons,
      'swaps': swaps,
      'time': elapsedSeconds,
      'arraySize': arraySize,
      'speed': speed,
      'progress': progress,
      'isSorted': isSorted,
    };
  }

  // ========== EQUALITY & HASHCODE ==========
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SortState &&
        other.currentIndex == currentIndex &&
        other.comparingIndex == comparingIndex &&
        other.pivotIndex == pivotIndex &&
        other.status == status &&
        other.comparisons == comparisons &&
        other.swaps == swaps &&
        other.arraySize == arraySize;
  }

  @override
  int get hashCode {
    return Object.hash(
      currentIndex,
      comparingIndex,
      pivotIndex,
      status,
      comparisons,
      swaps,
      arraySize,
    );
  }
}

// ========== EXTENSION FOR SORTSTATUS ==========

extension SortStatusExtension on SortStatus {
  /// Get display text untuk status
  String get displayText {
    switch (this) {
      case SortStatus.idle:
        return 'Ready';
      case SortStatus. sorting:
        return 'Sorting...';
      case SortStatus.paused:
        return 'Paused';
      case SortStatus.completed:
        return 'Completed! ';
      case SortStatus. stopped:
        return 'Stopped';
    }
  }

  /// Get icon untuk status
  String get icon {
    switch (this) {
      case SortStatus.idle:
        return '⏸️';
      case SortStatus.sorting:
        return '▶️';
      case SortStatus.paused:
        return '⏸️';
      case SortStatus.completed:
        return '✅';
      case SortStatus.stopped:
        return '⏹️';
    }
  }

  /// Check if status is terminal (completed or stopped)
  bool get isTerminal {
    return this == SortStatus.completed || this == SortStatus.stopped;
  }
}