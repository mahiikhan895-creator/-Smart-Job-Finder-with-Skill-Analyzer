// lib/repositories/job_repository.dart
import '../models/job_model.dart';
import '../models/application_model.dart';
import '../services/job_api_service.dart';
import '../database/local_database.dart';

class JobRepository {
  final JobApiService _apiService;
  final LocalDatabase _db;

  JobRepository({
    JobApiService? apiService,
    LocalDatabase? db,
  })  : _apiService = apiService ?? JobApiService(),
        _db = db ?? LocalDatabase.instance;

  /// Fetch jobs: try API first, fall back to local cache
  Future<List<Job>> getJobs({
    bool forceRefresh = false,
    String? search,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final offset = (page - 1) * pageSize;

    // Try API first
    try {
      final jobs = await _apiService.fetchJobs(
        search: search,
        limit: pageSize,
        offset: offset,
      );

      // Merge with local saved/view state to prevent data loss
      final enriched = jobs.map((job) {
        final local = _db.getJob(job.id);
        if (local != null) {
          return job.copyWith(
            isSaved: local.isSaved,
            viewCount: local.viewCount,
          );
        }
        return job;
      }).toList();

      // Cache to local DB (first page only to avoid duplicate sync)
      if (page == 1 && (search == null || search.isEmpty)) {
        await _db.saveJobs(enriched);
      }

      return enriched;
    } catch (e) {
      // Fallback to local cache
      return _getLocalJobs(
        search: search,
        category: category,
        offset: offset,
        limit: pageSize,
      );
    }
  }

  List<Job> _getLocalJobs({
    String? search,
    String? category,
    int offset = 0,
    int limit = 20,
  }) {
    var jobs = _db.getAllJobs();

    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      jobs = jobs
          .where((j) =>
      j.title.toLowerCase().contains(q) ||
          j.company.toLowerCase().contains(q) ||
          j.location.toLowerCase().contains(q))
          .toList();
    }

    if (category != null && category.isNotEmpty) {
      jobs = jobs
          .where((j) => j.employmentType.toLowerCase().contains(category.toLowerCase()))
          .toList();
    }

    if (offset < jobs.length) {
      return jobs.skip(offset).take(limit).toList();
    }
    return [];
  }

  /// Get a single job by ID
  Future<Job?> getJob(String id, {bool trackView = false}) async {
    Job? job = _db.getJob(id);
    if (trackView && job != null) {
      await _db.incrementJobView(id);
    }
    return job;
  }

  /// Toggle save state
  Future<void> toggleSaveJob(String jobId) async {
    final job = _db.getJob(jobId);
    if (job != null) {
      await _db.updateJobSaved(jobId, !job.isSaved);
    }
  }

  /// Get saved jobs
  List<Job> getSavedJobs() => _db.getSavedJobs();

  /// Applications
  Future<void> submitApplication(Job job) async {
    if (_db.hasApplied(job.id)) return; // prevent duplicates

    final app = JobApplication(
      id: '${job.id}_${DateTime.now().millisecondsSinceEpoch}',
      jobId: job.id,
      jobTitle: job.title,
      company: job.company,
      status: ApplicationStatus.applied.value,
      appliedDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );
    await _db.saveApplication(app);
  }

  Future<void> updateApplicationStatus(
      String applicationId, ApplicationStatus status) async {
    await _db.updateApplicationStatus(applicationId, status);
  }

  List<JobApplication> getAllApplications() => _db.getAllApplications();

  JobApplication? getApplicationForJob(String jobId) =>
      _db.getApplicationForJob(jobId);

  bool hasApplied(String jobId) => _db.hasApplied(jobId);

  /// Sync unsynced data when back online
  Future<void> syncPendingData() async {
    final unsynced = _db.getUnsyncedApplications();
    for (final app in unsynced) {
      // In a real app, POST to backend here
      await _db.markApplicationSynced(app.id);
    }
  }

  /// Search and filter local data
  List<Job> searchLocal({
    String? query,
    String? location,
    String? employmentType,
  }) {
    var jobs = _db.getAllJobs();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      jobs = jobs
          .where((j) =>
      j.title.toLowerCase().contains(q) ||
          j.company.toLowerCase().contains(q))
          .toList();
    }

    if (location != null && location.isNotEmpty) {
      jobs = jobs
          .where((j) => j.location.toLowerCase().contains(location.toLowerCase()))
          .toList();
    }

    if (employmentType != null && employmentType.isNotEmpty) {
      jobs = jobs
          .where((j) =>
          j.employmentType.toLowerCase().contains(employmentType.toLowerCase()))
          .toList();
    }

    return jobs;
  }

  void dispose() => _apiService.dispose();
}