import 'base_sort_algorithm.dart';

/// Insertion Sort Algorithm Implementation
/// Time Complexity:  O(n²)
/// Space Complexity: O(1)
class InsertionSortAlgorithm extends BaseSortAlgorithm {
  InsertionSortAlgorithm({
    required super.onStateUpdate,
    required super.initialState,
  });

  @override
  String get algorithmName => 'Insertion Sort';

  @override
  String get timeComplexity => 'O(n²)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  Future<void> sort() async {
    final n = length;

    await markSorted(0);

    for (int i = 1; i < n; i++) {
      if (shouldStop()) return;

      int key = getValue(i);
      int j = i - 1;

      await setComparing(i, j);

      while (j >= 0 && getValue(j) > key) {
        if (shouldStop()) return;

        await waitIfPaused();

        await setComparing(j, j + 1);

        await swap(j, j + 1);

        j--;

        if (j >= 0) {
          await setComparing(j, j + 1);
        }
      }

      await markRangeSorted(0, i);
    }

    clearHighlight();
  }
}