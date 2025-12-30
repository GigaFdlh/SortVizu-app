import 'base_sort_algorithm.dart';

/// Heap Sort Algorithm Implementation
/// Time Complexity: O(n log n)
/// Space Complexity: O(1)
class HeapSortAlgorithm extends BaseSortAlgorithm {
  HeapSortAlgorithm({
    required super.onStateUpdate,
    required super.initialState,
  });

  @override
  String get algorithmName => 'Heap Sort';

  @override
  String get timeComplexity => 'O(n log n)';

  @override
  String get spaceComplexity => 'O(1)';

  @override
  Future<void> sort() async {
    final n = length;

    // Build max heap
    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      if (shouldStop()) return;
      await _heapify(n, i);
    }

    // Extract elements from heap one by one
    for (int i = n - 1; i > 0; i--) {
      if (shouldStop()) return;

      // Move current root to end
      await swap(0, i);

      // Mark as sorted
      await markSorted(i);

      // Heapify reduced heap
      await _heapify(i, 0);
    }

    // Mark first element as sorted
    if (! shouldStop()) {
      await markSorted(0);
    }

    clearHighlight();
  }

  /// Heapify subtree rooted at index i
  Future<void> _heapify(int n, int i) async {
    if (shouldStop()) return;
    await waitIfPaused();

    int largest = i; // Initialize largest as root
    int left = 2 * i + 1; // Left child
    int right = 2 * i + 2; // Right child

    // Highlight current node
    await setComparing(i, i);

    // If left child is larger than root
    if (left < n) {
      await setComparing(i, left);
      if (compare(left, largest)) {
        largest = left;
      }
    }

    // If right child is larger than largest so far
    if (right < n) {
      await setComparing(largest, right);
      if (compare(right, largest)) {
        largest = right;
      }
    }

    // If largest is not root
    if (largest != i) {
      await swap(i, largest);

      // Recursively heapify the affected sub-tree
      await _heapify(n, largest);
    }
  }
}