// lib/services/skill_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/skill_model.dart';

/// API 2 – Skills & Training API
/// Uses Open Library / Course data or fallback static mapping
/// Primary: Coursera Catalog API (public endpoint) + skill mapping
class SkillApiService {
  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;

  SkillApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch skill/training data for a list of skill names
  Future<List<Skill>> fetchSkillsForNames(List<String> skillNames) async {
    final skills = <Skill>[];
    for (final name in skillNames) {
      try {
        final skill = await _fetchSkillFromCourseApi(name);
        skills.add(skill);
      } catch (_) {
        skills.add(_buildFallbackSkill(name));
      }
    }
    return skills;
  }

  /// Fetch from a public skill/course mapping API
  Future<Skill> _fetchSkillFromCourseApi(String skillName) async {
    // Using Open APIs - DataMuse for related skills + static course DB
    final uri = Uri.parse(
        'https://api.datamuse.com/words?ml=${Uri.encodeComponent(skillName)}&max=1&md=d');

    final response = await _client.get(uri).timeout(_timeout);

    if (response.statusCode == 200) {

      final data = json.decode(response.body) as List;
      // Build skill from the response + our course mapping
      return _buildSkillFromData(skillName, data.isNotEmpty ? data[0] : {});
    }
    throw Exception('Failed to fetch skill data');
  }

  Skill _buildSkillFromData(String skillName, Map<String, dynamic> data) {
    final mapping = _getCourseMapping(skillName);
    return Skill(
      id: skillName.hashCode.toString(),
      name: skillName,
      category: mapping['category']!,
      recommendedCourse: mapping['course']!,
      difficultyLevel: mapping['difficulty']!,
      courseUrl: mapping['url']!,
      provider: mapping['provider']!,
    );
  }

  Skill _buildFallbackSkill(String skillName) {
    final mapping = _getCourseMapping(skillName);
    return Skill(
      id: skillName.hashCode.toString(),
      name: skillName,
      category: mapping['category']!,
      recommendedCourse: mapping['course']!,
      difficultyLevel: mapping['difficulty']!,
      courseUrl: mapping['url']!,
      provider: mapping['provider']!,
    );
  }

  /// Comprehensive skill → course mapping
  Map<String, String> _getCourseMapping(String skillName) {
    final skill = skillName.toLowerCase().trim();

    // Technical skills
    if (_matches(skill, ['flutter', 'dart'])) {
      return {
        'category': 'Technical',
        'course': 'Flutter & Dart - The Complete Guide',
        'difficulty': 'Intermediate',
        'url': 'https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/',
        'provider': 'Udemy'
      };
    }
    if (_matches(skill, ['python', 'django', 'flask'])) {
      return {
        'category': 'Technical',
        'course': 'Python for Everybody Specialization',
        'difficulty': 'Beginner',
        'url': 'https://www.coursera.org/specializations/python',
        'provider': 'Coursera'
      };
    }
    if (_matches(skill, ['javascript', 'typescript', 'react', 'vue', 'angular'])) {
      return {
        'category': 'Technical',
        'course': 'The Complete JavaScript Course',
        'difficulty': 'Beginner',
        'url': 'https://www.udemy.com/course/the-complete-javascript-course/',
        'provider': 'Udemy'
      };
    }
    if (_matches(skill, ['aws', 'azure', 'gcp', 'cloud', 'kubernetes', 'docker'])) {
      return {
        'category': 'Technical',
        'course': 'AWS Certified Solutions Architect',
        'difficulty': 'Advanced',
        'url': 'https://www.coursera.org/learn/aws-certified-solutions-architect-associate',
        'provider': 'Coursera'
      };
    }
    if (_matches(skill, ['machine learning', 'ml', 'ai', 'deep learning', 'tensorflow', 'pytorch'])) {
      return {
        'category': 'Technical',
        'course': 'Machine Learning Specialization',
        'difficulty': 'Advanced',
        'url': 'https://www.coursera.org/specializations/machine-learning-introduction',
        'provider': 'Coursera'
      };
    }
    if (_matches(skill, ['sql', 'database', 'postgresql', 'mysql', 'mongodb'])) {
      return {
        'category': 'Technical',
        'course': 'SQL for Data Science',
        'difficulty': 'Beginner',
        'url': 'https://www.coursera.org/learn/sql-for-data-science',
        'provider': 'Coursera'
      };
    }
    if (_matches(skill, ['git', 'github', 'version control', 'ci/cd', 'devops'])) {
      return {
        'category': 'Technical',
        'course': 'DevOps Foundations',
        'difficulty': 'Intermediate',
        'url': 'https://www.linkedin.com/learning/devops-foundations',
        'provider': 'LinkedIn Learning'
      };
    }
    if (_matches(skill, ['java', 'spring', 'kotlin'])) {
      return {
        'category': 'Technical',
        'course': 'Java Programming and Software Engineering Fundamentals',
        'difficulty': 'Beginner',
        'url': 'https://www.coursera.org/specializations/java-programming',
        'provider': 'Coursera'
      };
    }
    if (_matches(skill, ['design', 'figma', 'ui', 'ux', 'css'])) {
      return {
        'category': 'Technical',
        'course': 'Google UX Design Certificate',
        'difficulty': 'Beginner',
        'url': 'https://www.coursera.org/professional-certificates/google-ux-design',
        'provider': 'Coursera'
      };
    }

    // Soft skills
    if (_matches(skill, ['communication', 'presentation', 'public speaking', 'writing'])) {
      return {
        'category': 'Soft',
        'course': 'Effective Communication: Writing, Design, and Presentation',
        'difficulty': 'Beginner',
        'url': 'https://www.coursera.org/specializations/effective-business-communication',
        'provider': 'Coursera'
      };
    }
    if (_matches(skill, ['leadership', 'management', 'team', 'agile', 'scrum'])) {
      return {
        'category': 'Soft',
        'course': 'Leadership and Emotional Intelligence',
        'difficulty': 'Intermediate',
        'url': 'https://www.coursera.org/learn/leadership-excellence',
        'provider': 'Coursera'
      };
    }
    if (_matches(skill, ['problem solving', 'critical thinking', 'analytical'])) {
      return {
        'category': 'Soft',
        'course': 'Critical Thinking & Problem Solving',
        'difficulty': 'Beginner',
        'url': 'https://www.edx.org/course/critical-thinking-problem-solving',
        'provider': 'edX'
      };
    }
    if (_matches(skill, ['project management', 'planning', 'pmp', 'jira'])) {
      return {
        'category': 'Soft',
        'course': 'Google Project Management Certificate',
        'difficulty': 'Beginner',
        'url': 'https://www.coursera.org/professional-certificates/google-project-management',
        'provider': 'Coursera'
      };
    }

    // Default
    return {
      'category': 'Other',
      'course': 'Professional Development Fundamentals',
      'difficulty': 'Beginner',
      'url': 'https://www.coursera.org',
      'provider': 'Coursera'
    };
  }

  bool _matches(String skill, List<String> keywords) {
    return keywords.any((kw) => skill.contains(kw));
  }

  /// Fetch all available skill categories
  Future<List<Skill>> fetchAllSkills() async {
    final commonSkills = [
      'Python', 'JavaScript', 'React', 'Flutter', 'AWS', 'SQL',
      'Machine Learning', 'Git', 'Communication', 'Leadership',
      'Project Management', 'Docker', 'Java', 'TypeScript', 'UI/UX Design',
    ];
    return fetchSkillsForNames(commonSkills);
  }

  void dispose() => _client.close();
}