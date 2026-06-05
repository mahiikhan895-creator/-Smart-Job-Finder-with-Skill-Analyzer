// lib/models/job_model.dart
import 'package:hive/hive.dart';

part 'job_model.g.dart';

@HiveType(typeId: 0)
class Job extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String company;

  @HiveField(3)
  final String location;

  @HiveField(4)
  final String employmentType;

  @HiveField(5)
  final String salaryRange;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final List<String> requiredSkills;

  @HiveField(8)
  final String logoUrl;

  @HiveField(9)
  final DateTime postedDate;

  @HiveField(10)
  bool isSaved;

  @HiveField(11)
  int viewCount;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.employmentType,
    required this.salaryRange,
    required this.description,
    required this.requiredSkills,
    this.logoUrl = '',
    required this.postedDate,
    this.isSaved = false,
    this.viewCount = 0,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['job_title'] ?? 'Unknown Title',
      company: json['company'] ?? json['company_name'] ?? 'Unknown Company',
      location: json['location'] ?? 'Remote',
      employmentType: json['employment_type'] ?? json['type'] ?? 'Full-time',
      salaryRange: _parseSalary(json),
      description: json['description'] ?? json['job_description'] ?? '',
      requiredSkills: _parseSkills(json),
      logoUrl: json['logo'] ?? json['company_logo'] ?? '',
      postedDate: _parseDate(json['created_at'] ?? json['posted_date']),
    );
  }

  static String _parseSalary(Map<String, dynamic> json) {
    if (json['salary'] != null) return json['salary'].toString();
    if (json['salary_min'] != null && json['salary_max'] != null) {
      return '\$${json['salary_min']}k - \$${json['salary_max']}k';
    }
    if (json['compensation'] != null) return json['compensation'].toString();
    return 'Competitive';
  }

  static List<String> _parseSkills(Map<String, dynamic> json) {
    final skills = json['skills'] ?? json['required_skills'] ?? json['tags'] ?? [];
    if (skills is List) return skills.map((s) => s.toString()).toList();
    if (skills is String) return skills.split(',').map((s) => s.trim()).toList();
    return [];
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'company': company,
    'location': location,
    'employment_type': employmentType,
    'salary': salaryRange,
    'description': description,
    'skills': requiredSkills,
    'logo': logoUrl,
    'posted_date': postedDate.toIso8601String(),
  };

  Job copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? employmentType,
    String? salaryRange,
    String? description,
    List<String>? requiredSkills,
    String? logoUrl,
    DateTime? postedDate,
    bool? isSaved,
    int? viewCount,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      employmentType: employmentType ?? this.employmentType,
      salaryRange: salaryRange ?? this.salaryRange,
      description: description ?? this.description,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      logoUrl: logoUrl ?? this.logoUrl,
      postedDate: postedDate ?? this.postedDate,
      isSaved: isSaved ?? this.isSaved,
      viewCount: viewCount ?? this.viewCount,
    );
  }
}