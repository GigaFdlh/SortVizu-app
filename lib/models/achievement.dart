import 'package:flutter/material.dart';

/// Achievement Model
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int target;
  final AchievementCategory category;
  
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.target,
    required this.category,
  });
}

/// Achievement Category
enum AchievementCategory {
  beginner,
  speed,
  completion,
  mastery,
  comparison,
}

extension AchievementCategoryExtension on AchievementCategory {
  String get displayName {
    switch (this) {
      case AchievementCategory.beginner:
        return 'Beginner';
      case AchievementCategory.speed:
        return 'Speed';
      case AchievementCategory. completion:
        return 'Completion';
      case AchievementCategory.mastery:
        return 'Mastery';
      case AchievementCategory. comparison:
        return 'Comparison';
    }
  }
}

/// All available achievements
class Achievements {
  static const List<Achievement> all = [
    Achievement(
      id: 'first_sort',
      title: 'First Steps',
      description: 'Complete your first sort',
      icon: Icons.flag,
      target: 1,
      category: AchievementCategory.beginner,
    ),
    Achievement(
      id:  'speed_demon_3s',
      title: 'Speed Demon',
      description: 'Complete a sort in under 3 seconds',
      icon: Icons.bolt,
      target: 1,
      category: AchievementCategory.speed,
    ),
    Achievement(
      id:  'speed_master_1s',
      title: 'Speed Master',
      description: 'Complete a sort in under 1 second',
      icon: Icons. flash_on,
      target: 1,
      category: AchievementCategory.speed,
    ),
    Achievement(
      id:  'algorithm_explorer',
      title: 'Algorithm Explorer',
      description: 'Try 3 different algorithms',
      icon: Icons.explore,
      target: 3,
      category: AchievementCategory.mastery,
    ),
    Achievement(
      id: 'algorithm_master',
      title: 'Algorithm Master',
      description: 'Try all 7 basic algorithms',
      icon: Icons. school,
      target: 7,
      category: AchievementCategory.mastery,
    ),
    Achievement(
      id:  'completionist_10',
      title: 'Getting Started',
      description: 'Complete 10 sorts',
      icon: Icons.check_circle,
      target: 10,
      category: AchievementCategory.completion,
    ),
    Achievement(
      id: 'completionist_50',
      title: 'Dedicated',
      description: 'Complete 50 sorts',
      icon:  Icons.star,
      target: 50,
      category: AchievementCategory.completion,
    ),
    Achievement(
      id: 'completionist_100',
      title: 'Completionist',
      description: 'Complete 100 sorts',
      icon: Icons.emoji_events,
      target: 100,
      category: AchievementCategory.completion,
    ),
    Achievement(
      id: 'comparison_winner',
      title: 'Comparison King',
      description: 'Win 5 comparison races',
      icon: Icons.emoji_events,
      target: 5,
      category: AchievementCategory.comparison,
    ),
    Achievement(
      id: 'perfectionist',
      title: 'Perfectionist',
      description:  'Complete a sort without pausing',
      icon: Icons. diamond,
      target: 1,
      category: AchievementCategory.mastery,
    ),
  ];

  static Achievement? getById(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }
}