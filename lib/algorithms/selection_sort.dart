import 'base_sort_algorithm.dart';

/// Selection Sort Algorithm Implementation
/// Time Complexity: O(n²)
/// Space Complexity: O(1)
class SelectionSortAlgorithm extends BaseSortAlgorithm {
  SelectionSortAlgorithm({
    required super.onStateUpdate,
    required super.initialState,
  });

  @override
  String get algorithmName => 'Selection Sort';

  @override
  String get timeComplexity => 'O(n²)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  Future<void> sort() async {
    final n = length;

    for (int i = 0; i < n - 1; i++) {
      if (shouldStop()) return;

      int minIndex = i;

      for (int j = i + 1; j < n; j++) {
        if (shouldStop()) return;

        await waitIfPaused();

        await setComparing(minIndex, j);

        if (compare(minIndex, j)) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        await swap(i, minIndex);
      }

      await markSorted(i);
    }

    if (!shouldStop()) {
      await markSorted(n - 1);
    }

    clearHighlight();
  }
}