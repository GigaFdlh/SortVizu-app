/// SortVizu Asset Paths
/// Central location for all asset file paths
class AppAssets {
  // Private constructor
  AppAssets._();

  // ========== IMAGES ==========
  
  /// Logo image (512x512 png)
  static const String logo = 'assets/images/logo.png';
  
  /// Splash background (optional, for special effects)
  static const String splashBg = 'assets/images/splash_bg.png';

  // ========== ALGORITHM ICONS (optional, for enhanced UI) ==========
  
  static const String iconBubble = 'assets/images/algorithm_icons/bubble.png';
  static const String iconSelection = 'assets/images/algorithm_icons/selection.png';
  static const String iconInsertion = 'assets/images/algorithm_icons/insertion.png';
  static const String iconMerge = 'assets/images/algorithm_icons/merge.png';
  static const String iconQuick = 'assets/images/algorithm_icons/quick. png';
  static const String iconHeap = 'assets/images/algorithm_icons/heap.png';
  static const String iconRadix = 'assets/images/algorithm_icons/radix.png';

  // ========== ANIMATIONS (Lottie - optional for Phase 2) ==========
  
  /// Sorting animation (Lottie JSON)
  static const String animSorting = 'assets/animations/sorting_animation.json';
  
  /// Success animation (Lottie JSON)
  static const String animSuccess = 'assets/animations/success. json';
  
  /// Loading animation (Lottie JSON)
  static const String animLoading = 'assets/animations/loading.json';

  // ========== PLACEHOLDER ICONS (Using Material Icons instead) ==========
  // Note:  Untuk fase 1, kita pakai Material Icons dulu (tidak perlu assets)
  // Icons ini untuk dokumentasi aja (kalau nanti mau pakai custom icons)
  
  // Icon names kita pakai nanti: 
  // - Icons.sort (for sorting general)
  // - Icons.compare_arrows (for comparisons)
  // - Icons.swap_horiz (for swaps)
  // - Icons.timer (for time)
  // - Icons.settings (for settings)
  // - Icons.info (for about)
}