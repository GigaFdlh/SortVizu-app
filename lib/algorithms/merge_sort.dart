import 'base_sort_algorithm.dart';

/// Merge Sort Algorithm Implementation
/// Time Complexity: O(n log n)
/// Space Complexity: O(n)
class MergeSortAlgorithm extends BaseSortAlgorithm {
  MergeSortAlgorithm({
    required super.onStateUpdate,
    required super.initialState,
  });

  @override
  String get algorithmName => 'Merge Sort';

  @override
  String get timeComplexity => 'O(n log n)';

  @override
  String get spaceComplexity => 'O(n)';

  @override
  Future<void> sort() async {
    await _mergeSort(0, length - 1);
    clearHighlight();
  }

  /// Recursive merge sort
  Future<void> _mergeSort(int left, int right) async {
    if (shouldStop()) return;
    if (left >= right) return;

    int mid = left + (right - left) ~/ 2;

    await _highlightRegion(left, right);

    await _mergeSort(left, mid);
    if (shouldStop()) return;

    await _mergeSort(mid + 1, right);
    if (shouldStop()) return;

    await _merge(left, mid, right);
  }

  /// Merge two sorted subarrays
  Future<void> _merge(int left, int mid, int right) async {
    if (shouldStop()) return;

    List<int> leftArray = [];
    List<int> rightArray = [];

    for (int i = left; i <= mid; i++) {
      leftArray.add(getValue(i));
    }
    for (int i = mid + 1; i <= right; i++) {
      rightArray.add(getValue(i));
    }

    int i = 0;
    int j = 0;
    int k = left;

    while (i < leftArray. length && j < rightArray.length) {
      if (shouldStop()) return;
      await waitIfPaused();

      await setComparing(k, k);

      if (leftArray[i] <= rightArray[j]) {
        await _updateValue(k, leftArray[i]);
        i++;
      } else {
        await _updateValue(k, rightArray[j]);
        j++;
      }
      k++;
    }

    while (i < leftArray.length) {
      if (shouldStop()) return;
      await waitIfPaused();
      await _updateValue(k, leftArray[i]);
      i++;
      k++;
    }

    while (j < rightArray.length) {
      if (shouldStop()) return;
      await waitIfPaused();
      await _updateValue(k, rightArray[j]);
      j++;
      k++;
    }

    await markRangeSorted(left, right);
  }

  /// Highlight region being processed
  Future<void> _highlightRegion(int left, int right) async {
    if (!isRunning) return;
    
    updateState(  // ← FIXED: Use updateState instead of _updateState
      currentState.copyWith(
        currentIndex: left,
        comparingIndex: right,
      ),
    );

    await delay();
  }

  /// Update value at specific index
  Future<void> _updateValue(int index, int value) async {
    if (!isRunning) return;

    final newNumbers = List<int>.from(currentState.numbers);
    newNumbers[index] = value;

    updateState(  // ← FIXED: Use updateState instead of _updateState
      currentState.copyWith(
        numbers: newNumbers,
        currentIndex: index,
        swaps: currentState.swaps + 1,
      ),
    );

    await delay();
  }
}