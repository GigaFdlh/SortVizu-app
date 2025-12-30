import 'package:sortvizu/core/enums/algorithm_type.dart';
import 'package:flutter/material.dart';

// ========== VISUALIZATION TYPE ENUM ==========
enum VisualizationType {
  barChart,
  scatterPlot,
  circular,
  wave,
  disparity,
}

/// Extension untuk tambah functionality ke VisualizationType
extension VisualizationTypeExtension on VisualizationType {
  
  // ========== DISPLAY NAME ==========
  String get displayName {
    switch (this) {
      case VisualizationType.barChart:
        return 'Bar Chart';
      case VisualizationType.scatterPlot:
        return 'Scatter Plot';
      case VisualizationType.circular:
        return 'Circular';
      case VisualizationType. wave:
        return 'Wave';
      case VisualizationType.disparity:
        return 'Disparity';
    }
  }

  // ========== DESCRIPTION ==========
  String get description {
    switch (this) {
      case VisualizationType.barChart:
        return 'Classic vertical bars showing element heights';
      case VisualizationType.scatterPlot:
        return 'Dots arranged in a grid, size represents value';
      case VisualizationType.circular:
        return 'Elements arranged in a circular/spiral pattern';
      case VisualizationType.wave:
        return 'Wave-like visualization, smooth and flowing';
      case VisualizationType.disparity:
        return 'Horizontal dots showing value disparity';
    }
  }

  // ========== NEW:  ICON GETTER (for Settings Screen) ==========
  IconData get icon {
    switch (this) {
      case VisualizationType.barChart:
        return Icons.bar_chart;
      case VisualizationType.scatterPlot:
        return Icons.scatter_plot;
      case VisualizationType.circular:
        return Icons.donut_large;
      case VisualizationType.wave:
        return Icons.graphic_eq;
      case VisualizationType.disparity:
        return Icons.horizontal_rule;
    }
  }
  // ============================================================

  // ========== ICON NAME (String - for legacy support) ==========
  String get iconName {
    switch (this) {
      case VisualizationType.barChart:
        return 'bar_chart';
      case VisualizationType. scatterPlot:
        return 'scatter_plot';
      case VisualizationType.circular:
        return 'donut_large';
      case VisualizationType.wave:
        return 'graphic_eq';
      case VisualizationType. disparity:
        return 'horizontal_rule';
    }
  }

  // ========== BEST FOR (Algorithm Recommendations) ==========
  List<AlgorithmType> get bestFor {
    switch (this) {
      case VisualizationType.barChart:
        return AlgorithmType.values;
      
      case VisualizationType.scatterPlot:
        return [
          AlgorithmType.merge,
          AlgorithmType. quick,
          AlgorithmType.heap,
        ];
      
      case VisualizationType.circular:
        return [
          AlgorithmType.radix,
          AlgorithmType. heap,
        ];
      
      case VisualizationType. wave:
        return [
          AlgorithmType.bubble,
          AlgorithmType.insertion,
        ];
      
      case VisualizationType.disparity:
        return [
          AlgorithmType.selection,
          AlgorithmType.insertion,
        ];
    }
  }

  // ========== COMPLEXITY (Rendering Performance) ==========
  int get renderingComplexity {
    switch (this) {
      case VisualizationType.barChart:
        return 1;
      case VisualizationType.scatterPlot:
        return 1;
      case VisualizationType.disparity:
        return 2;
      case VisualizationType.wave:
        return 2;
      case VisualizationType.circular:
        return 3;
    }
  }

  // ========== SUPPORTS LARGE ARRAYS ==========
  bool get supportsLargeArrays {
    switch (this) {
      case VisualizationType.barChart:
      case VisualizationType.scatterPlot:
      case VisualizationType.disparity:
        return true;
      case VisualizationType.wave:
      case VisualizationType. circular:
        return false;
    }
  }

  // ========== IS AVAILABLE ==========
  bool get isAvailable {
    switch (this) {
      case VisualizationType. barChart:
      case VisualizationType.scatterPlot:
        return true; // Phase 1 MVP
      case VisualizationType.circular:
      case VisualizationType.wave:
      case VisualizationType. disparity:
        return true;
    }
  }

  // ========== PREVIEW EMOJI (for UI) ==========
  String get previewEmoji {
    switch (this) {
      case VisualizationType.barChart:
        return '📊';
      case VisualizationType.scatterPlot:
        return '🔵';
      case VisualizationType. circular:
        return '⭕';
      case VisualizationType.wave:
        return '〰️';
      case VisualizationType.disparity:
        return '➖';
    }
  }
}

// ========== HELPER FUNCTIONS ==========

/// Get all available visualizations
List<VisualizationType> getAvailableVisualizations() {
  return VisualizationType.values. where((viz) => viz.isAvailable).toList();
}

/// Get recommended visualization for algorithm
VisualizationType getRecommendedVisualization(AlgorithmType algorithm) {
  VisualizationType recommended = VisualizationType.barChart;
  
  for (var viz in VisualizationType. values) {
    if (viz.isAvailable && viz.bestFor.contains(algorithm)) {
      if (viz.renderingComplexity <= recommended.renderingComplexity) {
        recommended = viz;
        break;
      }
    }
  }
  
  return recommended;
}

/// Get visualizations suitable for array size
List<VisualizationType> getVisualizationsForArraySize(int arraySize) {
  if (arraySize > 100) {
    return VisualizationType.values
        . where((viz) => viz.supportsLargeArrays && viz.isAvailable)
        .toList();
  } else {
    return getAvailableVisualizations();
  }
}