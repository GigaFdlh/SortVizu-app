class AppStrings {
  AppStrings._();

  static const String appName = 'SortVizu';

  static const String appTagline = 'Visualize Algorithms in Action';

  static const String appVersion = 'v1.0.0';

  static const String developerName = 'Giga Kurnia Fadhillah';

  static const String developerGitHub = 'github.com/gigafdlh';

  static const String homeTitle = 'Select Algorithm';

  static const String sortingTitle = 'Sorting Visualizer';

  static const String settingsTitle = 'Settings';

  static const String aboutTitle = 'About SortVizu';

  static const String btnStart = 'Start';

  static const String btnPause = 'Pause';

  static const String btnResume = 'Resume';

  static const String btnReset = 'Reset';

  static const String btnStop = 'Stop';

  static const String btnApply = 'Apply';

  static const String btnCancel = 'Cancel';

  static const String btnClose = 'Close';

  static const String btnOk = 'OK';

  static const String btnTryAgain = 'Try Again';

  static const String btnShare = 'Share';

  static const String labelArraySize = 'Array Size';

  static const String labelSpeed = 'Speed';

  static const String labelAlgorithm = 'Algorithm';

  static const String labelVisualization = 'Visualization';

  static const String labelComparisons = 'Comparisons';

  static const String labelSwaps = 'Swaps';

  static const String labelTime = 'Time';

  static const String labelComplexity = 'Complexity';

  static const String algoBubble = 'Bubble Sort';
  static const String algoSelection = 'Selection Sort';
  static const String algoInsertion = 'Insertion Sort';
  static const String algoMerge = 'Merge Sort';
  static const String algoQuick = 'Quick Sort';
  static const String algoHeap = 'Heap Sort';
  static const String algoRadix = 'Radix Sort';
  static const String algoBogo = 'Bogo Sort';
  static const String algoStalin = 'Stalin Sort';

  static const String descBubble =
      'Repeatedly compares adjacent elements and swaps them if in wrong order';
  static const String descSelection =
      'Finds minimum element and places it at the beginning';
  static const String descInsertion =
      'Builds sorted array one element at a time';
  static const String descMerge =
      'Divides array in half, sorts, then merges back';
  static const String descQuick =
      'Picks pivot, partitions around it recursively';
  static const String descHeap = 'Uses binary heap data structure to sort';
  static const String descRadix = 'Sorts integers digit by digit';
  static const String descBogo =
      'Randomly shuffles until sorted (don\'t use this!)';
  static const String descStalin =
      'Removes elements that are out of order (not real sorting!)';

  static const String complexityBubble = 'O(n²)';
  static const String complexitySelection = 'O(n²)';
  static const String complexityInsertion = 'O(n²)';
  static const String complexityMerge = 'O(n log n)';
  static const String complexityQuick = 'O(n log n)';
  static const String complexityHeap = 'O(n log n)';
  static const String complexityRadix = 'O(nk)';
  static const String complexityBogo = 'O(∞)';

  static const String statusReady = 'Ready to sort';

  static const String statusSorting = 'Sorting... ';

  static const String statusPaused = 'Paused';

  static const String statusCompleted = 'Sorting completed! ';

  static const String statusStopped = 'Stopped';

  static const String msgArrayGenerated = 'New array generated';

  static const String msgArrayShuffled = 'Array shuffled!  🎲';

  static const String msgSortingStarted = 'Sorting started';

  static const String msgSortingPaused = 'Sorting paused';

  static const String msgSortingResumed = 'Sorting resumed';

  static const String msgSortingCompleted = 'Sorting completed!  🎉';

  static const String msgSettingsSaved = 'Settings saved';

  static const String msgEasterEgg =
      '🎉 Exotic Mode Unlocked!\nTry Bogo Sort & Stalin Sort';

  static const String tooltipArraySize = 'Number of elements to sort';

  static const String tooltipSpeed =
      'Animation speed (milliseconds per operation)';

  static const String tooltipStart = 'Begin sorting animation';

  static const String tooltipPause = 'Pause sorting animation';

  static const String tooltipReset = 'Generate new random array';

  static const String menuHome = 'Home';
  static const String menuAlgorithms = 'Algorithms';
  static const String menuVisualizations = 'Visualizations';
  static const String menuSettings = 'Settings';
  static const String menuAbout = 'About';

  static const String settingsAppearance = 'Appearance';
  static const String settingsDefaults = 'Default Settings';
  static const String settingsAdvanced = 'Advanced';
  static const String settingsResetDefaults = 'Reset to Defaults';

  static const String settingTheme = 'Theme';
  static const String settingPrimaryColor = 'Primary Color';
  static const String settingFontSize = 'Font Size';
  static const String settingDefaultArraySize = 'Default Array Size';
  static const String settingDefaultSpeed = 'Default Animation Speed';
  static const String settingDefaultAlgorithm = 'Default Algorithm';
  static const String settingShowStats = 'Show Statistics';
  static const String settingSoundEffects = 'Sound Effects';
  static const String settingHapticFeedback = 'Haptic Feedback';

  static const String aboutDescription =
      'SortVizu is a professional sorting algorithm visualizer '
      'designed to help students and developers understand how '
      'different sorting algorithms work through interactive visualizations.';

  static const String aboutBuiltWith = 'Built with Flutter';
  static const String aboutLicense = 'License:  MIT';
  static const String aboutSpecialThanks = 'Special Thanks';
  static const String aboutFlutterTeam = 'Flutter Team';
  static const String aboutOpenSource = 'Open Source Community';

  static const String emptyNoAlgorithm = 'No algorithm selected';
  static const String emptyChooseAlgorithm =
      'Choose an algorithm to get started';
  static const String emptyNoData = 'No data available';

  static const String errorArrayTooLarge = 'Array too large for this device';
  static const String errorMaxElements = 'Maximum {max} elements';
  static const String errorSomethingWrong = 'Oops! Something went wrong';
  static const String errorTryAgain = 'Please try again';

  static const List<String> completionMessages = [
    'Sorted! 🎉',
    'Nailed it! ✨',
    'Perfectly balanced! 🔥',
    'Algorithm approved! ✓',
    'That was smooth! 🚀',
    'Mission accomplished! 🎯',
    'Flawless execution! 💎',
    'You\'re on fire! 🔥',
  ];
}
