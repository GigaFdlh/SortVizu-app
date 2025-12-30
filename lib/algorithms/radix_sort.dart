import 'base_sort_algorithm.dart';

/// Radix Sort Algorithm Implementation
/// Time Complexity: O(nk) where k is number of digits
/// Space Complexity: O(n + k)
class RadixSortAlgorithm extends BaseSortAlgorithm {
  RadixSortAlgorithm({
    required super.onStateUpdate,
    required super. initialState,
  });

  @override
  String get algorithmName => 'Radix Sort';

  @override
  String get timeComplexity => 'O(nk)';

  @override
  String get spaceComplexity => 'O(n+k)';

  @override
  Future<void> sort() async {
    if (length == 0) return;

    int maxValue = getValue(0);
    for (int i = 1; i < length; i++) {
      if (getValue(i) > maxValue) {
        maxValue = getValue(i);
      }
    }

    int exp = 1;
    while (maxValue ~/ exp > 0) {
      if (shouldStop()) return;
      await _countingSortByDigit(exp);
      exp *= 10;
    }

    await markRangeSorted(0, length - 1);
    clearHighlight();
  }

  Future<void> _countingSortByDigit(int exp) async {
    if (shouldStop()) return;

    final n = length;
    List<int> output = List.filled(n, 0);
    List<int> count = List.filled(10, 0);

    for (int i = 0; i < n; i++) {
      if (shouldStop()) return;
      int digit = (getValue(i) ~/ exp) % 10;
      count[digit]++;
      
      await setComparing(i, i);
    }

    for (int i = 1; i < 10; i++) {
      count[i] += count[i - 1];
    }

    for (int i = n - 1; i >= 0; i--) {
      if (shouldStop()) return;
      await waitIfPaused();

      int value = getValue(i);
      int digit = (value ~/ exp) % 10;
      output[count[digit] - 1] = value;
      count[digit]--;

      await setComparing(i, count[digit]);
    }

    for (int i = 0; i < n; i++) {
      if (shouldStop()) return;
      await _updateValue(i, output[i]);
    }
  }

  Future<void> _updateValue(int index, int value) async {
    if (!isRunning) return;

    final newNumbers = List<int>.from(currentState.numbers);
    newNumbers[index] = value;

    updateState(  // ← FIXED
      currentState.copyWith(
        numbers: newNumbers,
        currentIndex: index,
        swaps: currentState.swaps + 1,
      ),
    );

    await delay();
  }
}