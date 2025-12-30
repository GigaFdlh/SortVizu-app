import '../constants/app_strings.dart';
// ========== ALGORITHM TYPE ENUM ==========
enum AlgorithmType {
  bubble,
  selection,
  insertion,
  merge,
  quick,
  heap,
  radix,
  bogo,
  stalin,
}
extension AlgorithmTypeExtension on AlgorithmType {
  
  // ========== DISPLAY NAME ==========
  
  /// Get display name (user-friendly)
  String get displayName {
    switch (this) {
      case AlgorithmType.bubble:
        return AppStrings. algoBubble;
      case AlgorithmType.selection:
        return AppStrings.algoSelection;
      case AlgorithmType.insertion:
        return AppStrings.algoInsertion;
      case AlgorithmType.merge:
        return AppStrings.algoMerge;
      case AlgorithmType. quick:
        return AppStrings.algoQuick;
      case AlgorithmType.heap:
        return AppStrings.algoHeap;
      case AlgorithmType.radix:
        return AppStrings.algoRadix;
      case AlgorithmType.bogo:
        return AppStrings.algoBogo;
      case AlgorithmType.stalin:
        return AppStrings. algoStalin;
    }
  }

  // ========== DESCRIPTION ==========
  
  /// Get algorithm description (how it works)
  String get description {
    switch (this) {
      case AlgorithmType. bubble:
        return AppStrings.descBubble;
      case AlgorithmType.selection:
        return AppStrings.descSelection;
      case AlgorithmType.insertion:
        return AppStrings.descInsertion;
      case AlgorithmType. merge:
        return AppStrings.descMerge;
      case AlgorithmType.quick:
        return AppStrings.descQuick;
      case AlgorithmType.heap:
        return AppStrings.descHeap;
      case AlgorithmType. radix:
        return AppStrings.descRadix;
      case AlgorithmType.bogo:
        return AppStrings. descBogo;
      case AlgorithmType.stalin:
        return AppStrings. descStalin;
    }
  }

  // ========== TIME COMPLEXITY ==========
  
  /// Get time complexity (Big O notation)
  String get timeComplexity {
    switch (this) {
      case AlgorithmType.bubble:
        return AppStrings.complexityBubble;
      case AlgorithmType.selection:
        return AppStrings.complexitySelection;
      case AlgorithmType.insertion:
        return AppStrings. complexityInsertion;
      case AlgorithmType.merge:
        return AppStrings.complexityMerge;
      case AlgorithmType.quick:
        return AppStrings.complexityQuick;
      case AlgorithmType.heap:
        return AppStrings.complexityHeap;
      case AlgorithmType.radix:
        return AppStrings.complexityRadix;
      case AlgorithmType. bogo:
        return AppStrings.complexityBogo;
      case AlgorithmType.stalin:
        return 'O(n)';
    }
  }

  // ========== SPACE COMPLEXITY ==========
  
  /// Get space complexity (memory usage)
  String get spaceComplexity {
    switch (this) {
      case AlgorithmType.bubble:
      case AlgorithmType.selection:
      case AlgorithmType.insertion:
      case AlgorithmType.heap:
        return 'O(1)'; // In-place sorting
      case AlgorithmType.merge:
      case AlgorithmType.radix:
        return 'O(n)'; // Needs extra space
      case AlgorithmType.quick:
        return 'O(log n)'; // Recursion stack
      case AlgorithmType. bogo:
      case AlgorithmType.stalin:
        return 'O(1)';
    }
  }

  // ========== DIFFICULTY LEVEL ==========
  int get difficultyLevel {
    switch (this) {
      case AlgorithmType. bubble:
      case AlgorithmType.selection:
      case AlgorithmType. insertion:
        return 1;
      case AlgorithmType.merge:
      case AlgorithmType.quick:
      case AlgorithmType.heap:
        return 2;
      case AlgorithmType.radix:
        return 3;
      case AlgorithmType. bogo:
      case AlgorithmType.stalin:
        return 1;
    }
  }

  // ========== CATEGORY ==========
  AlgorithmCategory get category {
    switch (this) {
      case AlgorithmType.bubble:
      case AlgorithmType.selection:
      case AlgorithmType. insertion:
        return AlgorithmCategory.simple;
      case AlgorithmType.merge:
      case AlgorithmType.quick:
        return AlgorithmCategory.divideAndConquer;
      case AlgorithmType.heap:
        return AlgorithmCategory.heapBased;
      case AlgorithmType.radix:
        return AlgorithmCategory.nonComparison;
      case AlgorithmType.bogo:
      case AlgorithmType.stalin:
        return AlgorithmCategory.exotic;
    }
  }

  // ========== IS STABLE ==========
  bool get isStable {
    switch (this) {
      case AlgorithmType.bubble:
      case AlgorithmType.insertion:
      case AlgorithmType.merge:
      case AlgorithmType.radix:
        return true;
      case AlgorithmType.selection:
      case AlgorithmType.quick:
      case AlgorithmType.heap:
      case AlgorithmType.bogo:
      case AlgorithmType.stalin:
        return false;
    }
  }

  // ========== IS AVAILABLE (for progressive unlock) ==========
  bool get isAvailable {
    return true;
  }

  // ========== ICON ==========
  String get iconName {
    switch (this) {
      case AlgorithmType.bubble:
        return 'bubble_chart';
      case AlgorithmType.selection:
        return 'check_circle_outline';
      case AlgorithmType.insertion:
        return 'add_circle_outline';
      case AlgorithmType.merge:
        return 'merge_type';
      case AlgorithmType.quick:
        return 'flash_on';
      case AlgorithmType.heap:
        return 'account_tree';
      case AlgorithmType.radix:
        return 'filter_9_plus';
      case AlgorithmType.bogo:
        return 'shuffle';
      case AlgorithmType.stalin:
        return 'delete_sweep';
    }
  }
}

// ========== ALGORITHM CATEGORY ENUM ==========

/// Category untuk grouping algorithms
enum AlgorithmCategory {
  simple,
  divideAndConquer,
  heapBased,
  nonComparison,
  exotic,
}

extension AlgorithmCategoryExtension on AlgorithmCategory {
  String get displayName {
    switch (this) {
      case AlgorithmCategory.simple:
        return 'Simple Sorts';
      case AlgorithmCategory.divideAndConquer:
        return 'Divide & Conquer';
      case AlgorithmCategory.heapBased:
        return 'Heap-Based';
      case AlgorithmCategory.nonComparison:
        return 'Non-Comparison';
      case AlgorithmCategory.exotic:
        return 'Exotic (Fun!)';
    }
  }
}

// ========== HELPER FUNCTIONS ==========
List<AlgorithmType> getAlgorithmsByCategory(AlgorithmCategory category) {
  return AlgorithmType.values.where((algo) => algo.category == category).toList();
}
List<AlgorithmType> getAvailableAlgorithms() {
  return AlgorithmType.values.where((algo) => algo.isAvailable).toList();
}
List<AlgorithmType> getBasicAlgorithms() {
  return [
    AlgorithmType.bubble,
    AlgorithmType. selection,
    AlgorithmType.insertion,
  ];
}
List<AlgorithmType> getAdvancedAlgorithms() {
  return [
    AlgorithmType.merge,
    AlgorithmType.quick,
    AlgorithmType.heap,
    AlgorithmType.radix,
  ];
}
List<AlgorithmType> getExoticAlgorithms() {
  return [
    AlgorithmType.bogo,
    AlgorithmType. stalin,
  ];
}