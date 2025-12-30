import 'package:shared_preferences/shared_preferences.dart';
import '../enums/visualization_type.dart';

/// Manages user preferences using SharedPreferences
class PreferencesManager {
  static final PreferencesManager _instance = PreferencesManager._internal();
  factory PreferencesManager() => _instance;
  PreferencesManager._internal();

  SharedPreferences? _prefs;

  // ========== KEYS ==========
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyDefaultArraySize = 'default_array_size';
  static const String _keyDefaultSpeed = 'default_speed';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyHapticEnabled = 'haptic_enabled';
  static const String _keyDefaultVisualization = 'default_visualization';
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyTotalSorts = 'total_sorts';
  static const String _keyFastestSortTime = 'fastest_sort_time';

  // ========== INITIALIZATION ==========

  /// Initialize SharedPreferences (call at app startup)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Check if preferences are ready
  bool get isReady => _prefs != null; // ← ADD THIS

  /// Ensure preferences are loaded (with safe fallback)
  SharedPreferences?  get prefs => _prefs; // ← CHANGED:  Make nullable

  // ========== THEME ==========

  /// Get theme mode ('dark', 'light', 'system')
  String getThemeMode() {
    return prefs?.getString(_keyThemeMode) ?? 'dark'; // ← ADD ?  operator
  }

  /// Set theme mode
  Future<bool> setThemeMode(String mode) async {
    if (! isReady) return false; // ← ADD CHECK
    return await prefs! .setString(_keyThemeMode, mode);
  }

  // ========== ARRAY SIZE ==========

  /// Get default array size (10-100)
  int getDefaultArraySize() {
    return prefs?.getInt(_keyDefaultArraySize) ?? 50; // ← ADD ? 
  }

  /// Set default array size
  Future<bool> setDefaultArraySize(int size) async {
    if (!isReady) return false;
    return await prefs!. setInt(_keyDefaultArraySize, size);
  }

  // ========== SPEED ==========

  /// Get default speed in milliseconds (1-500)
  int getDefaultSpeed() {
    return prefs?.getInt(_keyDefaultSpeed) ?? 100; // ← ADD ?
  }

  /// Set default speed
  Future<bool> setDefaultSpeed(int speed) async {
    if (!isReady) return false;
    return await prefs!.setInt(_keyDefaultSpeed, speed);
  }

  // ========== SOUND & HAPTIC ==========

  /// Get sound enabled status
  bool getSoundEnabled() {
    return prefs?.getBool(_keySoundEnabled) ?? true; // ← ADD ?  (default ON)
  }

  /// Set sound enabled
  Future<bool> setSoundEnabled(bool enabled) async {
    if (!isReady) return false;
    return await prefs!.setBool(_keySoundEnabled, enabled);
  }

  /// Get haptic enabled status
  bool getHapticEnabled() {
    return prefs?.getBool(_keyHapticEnabled) ?? true; // ← ADD ? (default ON)
  }

  /// Set haptic enabled
  Future<bool> setHapticEnabled(bool enabled) async {
    if (!isReady) return false;
    return await prefs!.setBool(_keyHapticEnabled, enabled);
  }

  // ========== VISUALIZATION ==========

  /// Get default visualization type
  VisualizationType getDefaultVisualization() {
    final value = prefs?.getString(_keyDefaultVisualization); // ← ADD ?
    if (value == null) return VisualizationType.barChart;
    
    try {
      return VisualizationType.values. firstWhere(
        (e) => e.toString() == value,
        orElse: () => VisualizationType.barChart,
      );
    } catch (e) {
      return VisualizationType.barChart;
    }
  }

  /// Set default visualization
  Future<bool> setDefaultVisualization(VisualizationType type) async {
    if (!isReady) return false;
    return await prefs!.setString(_keyDefaultVisualization, type. toString());
  }

  // ========== FIRST LAUNCH ==========

  /// Check if this is first launch
  bool isFirstLaunch() {
    return prefs?.getBool(_keyFirstLaunch) ?? true; // ← ADD ?
  }

  /// Mark first launch as complete
  Future<bool> setFirstLaunchComplete() async {
    if (!isReady) return false;
    return await prefs!. setBool(_keyFirstLaunch, false);
  }

  // ========== STATS ==========

  /// Get total sorts completed
  int getTotalSorts() {
    return prefs?.getInt(_keyTotalSorts) ?? 0; // ← ADD ? 
  }

  /// Increment total sorts
  Future<bool> incrementTotalSorts() async {
    if (!isReady) return false;
    final current = getTotalSorts();
    return await prefs!.setInt(_keyTotalSorts, current + 1);
  }

  /// Get fastest sort time in milliseconds
  int getFastestSortTime() {
    return prefs?.getInt(_keyFastestSortTime) ?? 0; // ← ADD ? 
  }

  /// Update fastest sort time
  Future<bool> updateFastestSortTime(int timeMs) async {
    if (!isReady) return false;
    final current = getFastestSortTime();
    if (current == 0 || timeMs < current) {
      return await prefs!.setInt(_keyFastestSortTime, timeMs);
    }
    return false;
  }

  // ========== RESET ==========

  /// Reset all preferences to defaults
  Future<bool> resetToDefaults() async {
    if (!isReady) return false;
    await prefs!.clear();
    return true;
  }

  /// Reset only settings (keep stats)
  Future<bool> resetSettings() async {
    if (!isReady) return false;
    await setThemeMode('dark');
    await setDefaultArraySize(50);
    await setDefaultSpeed(100);
    await setSoundEnabled(true);
    await setHapticEnabled(true);
    await setDefaultVisualization(VisualizationType.barChart);
    return true;
  }
}