// lib/models/skill_model.dart
import 'package:hive/hive.dart';

part 'skill_model.g.dart';

enum SkillCategory { technical, soft, other }

@HiveType(typeId: 1)
class Skill extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category; // 'Technical', 'Soft', 'Other'

  @HiveField(3)
  final String recommendedCourse;

  @HiveField(4)
  final String difficultyLevel; // 'Beginner', 'Intermediate', 'Advanced'

  @HiveField(5)
  final String courseUrl;

  @HiveField(6)
  final String provider; // e.g., Coursera, Udemy

  Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.recommendedCourse,
    required this.difficultyLevel,
    this.courseUrl = '',
    this.provider = '',
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['skill_name'] ?? '',
      category: _parseCategory(json),
      recommendedCourse: json['recommended_course'] ??
          json['course'] ??
          json['training'] ??
          'Self-study',
      difficultyLevel: json['difficulty'] ??
          json['difficulty_level'] ??
          json['level'] ??
          'Beginner',
      courseUrl: json['course_url'] ?? json['url'] ?? '',
      provider: json['provider'] ?? json['platform'] ?? '',
    );
  }

  static String _parseCategory(Map<String, dynamic> json) {
    final cat = (json['category'] ?? json['skill_category'] ?? '').toString().toLowerCase();
    if (cat.contains('tech') || cat.contains('hard')) return 'Technical';
    if (cat.contains('soft') || cat.contains('interpersonal')) return 'Soft';
    return 'Other';
  }

  SkillCategory get categoryEnum {
    switch (category.toLowerCase()) {
      case 'technical':
        return SkillCategory.technical;
      case 'soft':
        return SkillCategory.soft;
      default:
        return SkillCategory.other;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'recommended_course': recommendedCourse,
    'difficulty': difficultyLevel,
    'course_url': courseUrl,
    'provider': provider,
  };
}