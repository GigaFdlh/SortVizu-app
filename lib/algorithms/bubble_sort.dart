import 'base_sort_algorithm.dart';

/// Bubble Sort Algorithm Implementation
/// Time Complexity: O(n²)
/// Space Complexity: O(1)
class BubbleSortAlgorithm extends BaseSortAlgorithm {
  BubbleSortAlgorithm({
    required super. onStateUpdate,
    required super.initialState,
  });

  @override
  String get algorithmName => 'Bubble Sort';

  @override
  String get timeComplexity => 'O(n²)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  Future<void> sort() async {
    final n = length;

    for (int i = 0; i < n - 1; i++) {
      if (shouldStop()) return;

      bool swapped = false;

      for (int j = 0; j < n - i - 1; j++) {
        if (shouldStop()) return;

        await waitIfPaused();

        await setComparing(j, j + 1);

        if (compare(j, j + 1)) {
          await swap(j, j + 1);
          swapped = true;
        }
      }

      await markSorted(n - i - 1);

      if (!swapped) {
        await markRangeSorted(0, n - i - 2);
        break;
      }
    }

    if (! shouldStop()) {
      await markSorted(0);
    }

    clearHighlight();
  }
}