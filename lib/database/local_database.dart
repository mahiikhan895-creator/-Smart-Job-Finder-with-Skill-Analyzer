// lib/database/local_database.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/job_model.dart';
import '../models/skill_model.dart';
import '../models/application_model.dart';

class LocalDatabase {
  static const String _jobsBox = 'jobs';
  static const String _skillsBox = 'skills';
  static const String _applicationsBox = 'applications';
  static const String _analyticsBox = 'analytics';

  static LocalDatabase? _instance;
  static LocalDatabase get instance => _instance ??= LocalDatabase._();
  LocalDatabase._();

  // ─── Initialization ───────────────────────────────────────────
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(JobAdapter());
    Hive.registerAdapter(SkillAdapter());
    Hive.registerAdapter(JobApplicationAdapter());
    await Hive.openBox<Job>(_jobsBox);
    await Hive.openBox<Skill>(_skillsBox);
    await Hive.openBox<JobApplication>(_applicationsBox);
    await Hive.openBox<dynamic>(_analyticsBox);
  }

  Box<Job> get _jobs => Hive.box<Job>(_jobsBox);
  Box<Skill> get _skills => Hive.box<Skill>(_skillsBox);
  Box<JobApplication> get _applications => Hive.box<JobApplication>(_applicationsBox);
  Box<dynamic> get _analytics => Hive.box<dynamic>(_analyticsBox);

  // ─── Jobs ──────────────────────────────────────────────────────
  Future<void> saveJobs(List<Job> jobs) async {
    final map = {for (final j in jobs) j.id: j};
    await _jobs.putAll(map);
  }

  Future<void> saveJob(Job job) async {
    await _jobs.put(job.id, job);
  }

  List<Job> getAllJobs() => _jobs.values.toList();

  Job? getJob(String id) => _jobs.get(id);

  Future<void> updateJobSaved(String id, bool isSaved) async {
    final job = _jobs.get(id);
    if (job != null) {
      final updated = job.copyWith(isSaved: isSaved);
      await _jobs.put(id, updated);
    }
  }

  Future<void> incrementJobView(String id) async {
    final job = _jobs.get(id);
    if (job != null) {
      final updated = job.copyWith(viewCount: job.viewCount + 1);
      await _jobs.put(id, updated);
    }
    // Also increment analytics counter
    final current = _analytics.get('total_views', defaultValue: 0) as int;
    await _analytics.put('total_views', current + 1);
  }

  List<Job> getSavedJobs() =>
      _jobs.values.where((j) => j.isSaved).toList();

  // ─── Skills ────────────────────────────────────────────────────
  Future<void> saveSkills(List<Skill> skills) async {
    final map = {for (final s in skills) s.id: s};
    await _skills.putAll(map);
  }

  List<Skill> getSkillsForNames(List<String> names) {
    final lowerNames = names.map((n) => n.toLowerCase()).toSet();
    return _skills.values
        .where((s) => lowerNames.contains(s.name.toLowerCase()))
        .toList();
  }

  List<Skill> getAllSkills() => _skills.values.toList();

  // ─── Applications ──────────────────────────────────────────────
  Future<void> saveApplication(JobApplication app) async {
    await _applications.put(app.id, app);
  }

  Future<void> updateApplicationStatus(String id, ApplicationStatus status) async {
    final app = _applications.get(id);
    if (app != null) {
      app.applicationStatus = status;
      app.synced = false;
      await app.save();
    }
  }

  List<JobApplication> getAllApplications() =>
      _applications.values.toList()
        ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

  JobApplication? getApplicationForJob(String jobId) =>
      _applications.values.cast<JobApplication?>().firstWhere(
              (a) => a?.jobId == jobId,
          orElse: () => null);

  List<JobApplication> getUnsyncedApplications() =>
      _applications.values.where((a) => !a.synced).toList();

  Future<void> markApplicationSynced(String id) async {
    final app = _applications.get(id);
    if (app != null) {
      app.synced = true;
      await app.save();
    }
  }

  Future<void> deleteApplication(String id) async {
    await _applications.delete(id);
  }

  bool hasApplied(String jobId) =>
      _applications.values.any((a) => a.jobId == jobId);

  // ─── Analytics ─────────────────────────────────────────────────
  int getTotalViews() =>
      _analytics.get('total_views', defaultValue: 0) as int;

  int getTotalSaved() => getSavedJobs().length;

  int getTotalApplications() => _applications.length;

  Map<String, int> getStatusDistribution() {
    final apps = getAllApplications();
    return {
      'Applied': apps.where((a) => a.status == 'applied').length,
      'Interview Scheduled':
      apps.where((a) => a.status == 'interview_scheduled').length,
      'Rejected': apps.where((a) => a.status == 'rejected').length,
      'Accepted': apps.where((a) => a.status == 'accepted').length,
    };
  }

  String getMostCommonSkillCategory() {
    final skills = getAllSkills();
    if (skills.isEmpty) return 'N/A';
    final counts = <String, int>{};
    for (final s in skills) {
      counts[s.category] = (counts[s.category] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  String getMostRecommendedCourse() {
    final skills = getAllSkills();
    if (skills.isEmpty) return 'N/A';
    final counts = <String, int>{};
    for (final s in skills) {
      counts[s.provider] = (counts[s.provider] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  // ─── Cleanup ───────────────────────────────────────────────────
  Future<void> clearAll() async {
    await _jobs.clear();
    await _skills.clear();
    await _applications.clear();
    await _analytics.clear();
  }
}