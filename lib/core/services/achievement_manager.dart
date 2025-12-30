import 'package:shared_preferences/shared_preferences.dart';
import '../../models/achievement.dart';
import '../enums/algorithm_type.dart';

/// Achievement Manager - Track and unlock achievements
class AchievementManager {
  static final AchievementManager _instance = AchievementManager._internal();
  factory AchievementManager() => _instance;
  AchievementManager._internal();

  SharedPreferences? _prefs;

  // Keys
  static const String _keyUnlockedAchievements = 'unlocked_achievements';
  static const String _keyAlgorithmsTried = 'algorithms_tried';
  static const String _keyComparisonWins = 'comparison_wins';
  static const String _keyPerfectSorts = 'perfect_sorts';

  // ========== INITIALIZATION ==========

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ========== GETTERS ==========

  List<String> getUnlockedAchievements() {
    return _prefs?.getStringList(_keyUnlockedAchievements) ?? [];
  }

  bool isUnlocked(String achievementId) {
    return getUnlockedAchievements().contains(achievementId);
  }

  int getUnlockedCount() {
    return getUnlockedAchievements().length;
  }

  List<String> getAlgorithmsTried() {
    return _prefs?. getStringList(_keyAlgorithmsTried) ?? [];
  }

  int getComparisonWins() {
    return _prefs?.getInt(_keyComparisonWins) ?? 0;
  }

  int getPerfectSorts() {
    return _prefs?.getInt(_keyPerfectSorts) ?? 0;
  }

  // ========== SETTERS ==========

  Future<void> unlockAchievement(String achievementId) async {
    final unlocked = getUnlockedAchievements();
    if (!unlocked.contains(achievementId)) {
      unlocked.add(achievementId);
      await _prefs?.setStringList(_keyUnlockedAchievements, unlocked);
    }
  }

  Future<void> addAlgorithmTried(AlgorithmType algorithm) async {
    final tried = getAlgorithmsTried();
    final algorithmName = algorithm.name;
    if (!tried.contains(algorithmName)) {
      tried.add(algorithmName);
      await _prefs?.setStringList(_keyAlgorithmsTried, tried);
    }
  }

  Future<void> incrementComparisonWins() async {
    final wins = getComparisonWins() + 1;
    await _prefs?.setInt(_keyComparisonWins, wins);
  }

  Future<void> incrementPerfectSorts() async {
    final perfect = getPerfectSorts() + 1;
    await _prefs?.setInt(_keyPerfectSorts, perfect);
  }

  // ========== CHECK & UNLOCK ==========

  /// Check all achievements and return newly unlocked ones
  Future<List<Achievement>> checkAchievements({
    required int totalSorts,
    required int fastestTime,
    bool isPerfectSort = false,
  }) async {
    final newlyUnlocked = <Achievement>[];

    for (final achievement in Achievements.all) {
      if (isUnlocked(achievement.id)) continue;

      bool shouldUnlock = false;

      switch (achievement.id) {
        case 'first_sort':
          shouldUnlock = totalSorts >= 1;
          break;

        case 'speed_demon_3s':
          shouldUnlock = fastestTime > 0 && fastestTime < 3000;
          break;

        case 'speed_master_1s':
          shouldUnlock = fastestTime > 0 && fastestTime < 1000;
          break;

        case 'algorithm_explorer':
          shouldUnlock = getAlgorithmsTried().length >= 3;
          break;

        case 'algorithm_master': 
          shouldUnlock = getAlgorithmsTried().length >= 7;
          break;

        case 'completionist_10': 
          shouldUnlock = totalSorts >= 10;
          break;

        case 'completionist_50':
          shouldUnlock = totalSorts >= 50;
          break;

        case 'completionist_100': 
          shouldUnlock = totalSorts >= 100;
          break;

        case 'comparison_winner':
          shouldUnlock = getComparisonWins() >= 5;
          break;

        case 'perfectionist':
          shouldUnlock = isPerfectSort && getPerfectSorts() >= 1;
          break;
      }

      if (shouldUnlock) {
        await unlockAchievement(achievement.id);
        newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }
}