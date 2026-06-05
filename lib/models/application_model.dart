// lib/models/application_model.dart
import 'package:hive/hive.dart';

part 'application_model.g.dart';

enum ApplicationStatus { applied, interviewScheduled, rejected, accepted }

extension ApplicationStatusExtension on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.interviewScheduled:
        return 'Interview Scheduled';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.accepted:
        return 'Accepted';
    }
  }

  String get value {
    switch (this) {
      case ApplicationStatus.applied:
        return 'applied';
      case ApplicationStatus.interviewScheduled:
        return 'interview_scheduled';
      case ApplicationStatus.rejected:
        return 'rejected';
      case ApplicationStatus.accepted:
        return 'accepted';
    }
  }

  static ApplicationStatus fromString(String value) {
    switch (value) {
      case 'applied':
        return ApplicationStatus.applied;
      case 'interview_scheduled':
        return ApplicationStatus.interviewScheduled;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'accepted':
        return ApplicationStatus.accepted;
      default:
        return ApplicationStatus.applied;
    }
  }
}

@HiveType(typeId: 2)
class JobApplication extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String jobId;

  @HiveField(2)
  final String jobTitle;

  @HiveField(3)
  final String company;

  @HiveField(4)
  String status; // stored as string

  @HiveField(5)
  final DateTime appliedDate;

  @HiveField(6)
  DateTime updatedDate;

  @HiveField(7)
  String notes;

  @HiveField(8)
  bool synced;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.company,
    required this.status,
    required this.appliedDate,
    required this.updatedDate,
    this.notes = '',
    this.synced = false,
  });

  ApplicationStatus get applicationStatus =>
      ApplicationStatusExtension.fromString(status);

  set applicationStatus(ApplicationStatus s) {
    status = s.value;
    updatedDate = DateTime.now();
    synced = false;
  }

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id']?.toString() ?? '',
      jobId: json['job_id']?.toString() ?? '',
      jobTitle: json['job_title'] ?? '',
      company: json['company'] ?? '',
      status: json['status'] ?? 'applied',
      appliedDate: DateTime.tryParse(json['applied_date'] ?? '') ?? DateTime.now(),
      updatedDate: DateTime.tryParse(json['updated_date'] ?? '') ?? DateTime.now(),
      notes: json['notes'] ?? '',
      synced: json['synced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'job_id': jobId,
    'job_title': jobTitle,
    'company': company,
    'status': status,
    'applied_date': appliedDate.toIso8601String(),
    'updated_date': updatedDate.toIso8601String(),
    'notes': notes,
    'synced': synced,
  };
}