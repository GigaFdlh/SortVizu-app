import 'base_sort_algorithm.dart';

/// Quick Sort Algorithm Implementation
/// Time Complexity:  O(n log n) average, O(n²) worst
/// Space Complexity: O(log n)
class QuickSortAlgorithm extends BaseSortAlgorithm {
  QuickSortAlgorithm({
    required super.onStateUpdate,
    required super.initialState,
  });

  @override
  String get algorithmName => 'Quick Sort';

  @override
  String get timeComplexity => 'O(n log n)';

  @override
  String get spaceComplexity => 'O(log n)';

  @override
  Future<void> sort() async {
    await _quickSort(0, length - 1);
    clearHighlight();
  }

  Future<void> _quickSort(int low, int high) async {
    if (shouldStop()) return;
    if (low < high) {
      int pivotIndex = await _partition(low, high);
      
      if (shouldStop()) return;

      await markSorted(pivotIndex);

      await _quickSort(low, pivotIndex - 1);
      
      if (shouldStop()) return;

      await _quickSort(pivotIndex + 1, high);
    } else if (low == high) {
      await markSorted(low);
    }
  }

  Future<int> _partition(int low, int high) async {
    if (shouldStop()) return low;

    int pivotValue = getValue(high);

    updateState(  // ← FIXED
      currentState.copyWith(pivotIndex: high),
    );
    await delay();

    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (shouldStop()) return i + 1;
      await waitIfPaused();

      await setComparing(j, high);

      if (getValue(j) < pivotValue) {
        i++;
        if (i != j) {
          await swap(i, j);
        }
      }
    }

    if (i + 1 != high) {
      await swap(i + 1, high);
    }

    updateState(  // ← FIXED
      currentState.copyWith(clearPivotIndex: true),
    );

    return i + 1;
  }
}