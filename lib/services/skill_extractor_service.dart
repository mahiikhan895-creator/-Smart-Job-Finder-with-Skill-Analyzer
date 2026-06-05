// lib/services/skill_extractor_service.dart
import '../models/skill_model.dart';

/// Extracts and categorizes skills from job descriptions
class SkillExtractorService {
  static const Map<String, String> _technicalSkillKeywords = {
    'python': 'Python',
    'javascript': 'JavaScript',
    'typescript': 'TypeScript',
    'react': 'React',
    'vue': 'Vue.js',
    'angular': 'Angular',
    'flutter': 'Flutter',
    'dart': 'Dart',
    'java': 'Java',
    'kotlin': 'Kotlin',
    'swift': 'Swift',
    'c++': 'C++',
    'c#': 'C#',
    'golang': 'Go',
    'rust': 'Rust',
    'ruby': 'Ruby',
    'php': 'PHP',
    'sql': 'SQL',
    'postgresql': 'PostgreSQL',
    'mysql': 'MySQL',
    'mongodb': 'MongoDB',
    'redis': 'Redis',
    'aws': 'AWS',
    'azure': 'Azure',
    'gcp': 'GCP',
    'docker': 'Docker',
    'kubernetes': 'Kubernetes',
    'git': 'Git',
    'github': 'GitHub',
    'ci/cd': 'CI/CD',
    'devops': 'DevOps',
    'machine learning': 'Machine Learning',
    'deep learning': 'Deep Learning',
    'tensorflow': 'TensorFlow',
    'pytorch': 'PyTorch',
    'api': 'API Development',
    'rest': 'REST APIs',
    'graphql': 'GraphQL',
    'linux': 'Linux',
    'figma': 'Figma',
    'ui/ux': 'UI/UX Design',
    'node': 'Node.js',
    'django': 'Django',
    'spring': 'Spring Boot',
  };

  static const Map<String, String> _softSkillKeywords = {
    'communication': 'Communication',
    'leadership': 'Leadership',
    'team': 'Teamwork',
    'collaboration': 'Collaboration',
    'problem.solving': 'Problem Solving',
    'critical thinking': 'Critical Thinking',
    'agile': 'Agile Methodology',
    'scrum': 'Scrum',
    'project management': 'Project Management',
    'time management': 'Time Management',
    'adaptability': 'Adaptability',
    'creativity': 'Creativity',
    'analytical': 'Analytical Thinking',
    'presentation': 'Presentation Skills',
    'mentoring': 'Mentoring',
    'interpersonal': 'Interpersonal Skills',
    'organization': 'Organization',
    'detail.oriented': 'Attention to Detail',
    'multitask': 'Multitasking',
  };

  /// Extract and categorize skills from a job description
  Map<SkillCategory, List<String>> extractSkills(String description) {
    final lower = description.toLowerCase();
    final technical = <String>{};
    final soft = <String>{};

    // Extract technical skills
    for (final entry in _technicalSkillKeywords.entries) {
      if (lower.contains(entry.key)) {
        technical.add(entry.value);
      }
    }

    // Extract soft skills
    for (final entry in _softSkillKeywords.entries) {
      final pattern = RegExp(entry.key.replaceAll('.', r'\s'));
      if (pattern.hasMatch(lower)) {
        soft.add(entry.value);
      }
    }

    return {
      SkillCategory.technical: technical.toList(),
      SkillCategory.soft: soft.toList(),
      SkillCategory.other: [],
    };
  }

  /// Get all unique skills from description as flat list
  List<String> extractAllSkillNames(String description) {
    final categorized = extractSkills(description);
    return [
      ...categorized[SkillCategory.technical] ?? [],
      ...categorized[SkillCategory.soft] ?? [],
    ];
  }
}