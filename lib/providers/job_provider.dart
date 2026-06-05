// lib/providers/job_provider.dart
import 'package:flutter/foundation.dart';
import '../models/job_model.dart';
import '../models/application_model.dart';
import '../repositories/job_repository.dart';
import '../services/connectivity_service.dart';

enum LoadingState { idle, loading, loaded, error }

class JobProvider extends ChangeNotifier {
  final JobRepository _repository;
  final ConnectivityService _connectivity;

  JobProvider({
    JobRepository? repository,
    ConnectivityService? connectivity,
  })  : _repository = repository ?? JobRepository(),
        _connectivity = connectivity ?? ConnectivityService() {
    _listenToConnectivity();
  }

  // State
  LoadingState _state = LoadingState.idle;
  List<Job> _jobs = [];
  List<Job> _filteredJobs = [];
  String? _errorMessage;
  bool _isOnline = true;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // Filters
  String _searchQuery = '';
  String _locationFilter = '';
  String _typeFilter = '';

  // Getters
  LoadingState get state => _state;
  List<Job> get jobs => _filteredJobs.isEmpty && _searchQuery.isEmpty
      ? _jobs
      : _filteredJobs;
  String? get errorMessage => _errorMessage;
  bool get isOnline => _isOnline;
  bool get isLoading => _state == LoadingState.loading;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  String get searchQuery => _searchQuery;
  String get locationFilter => _locationFilter;
  String get typeFilter => _typeFilter;
  List<Job> get savedJobs => _repository.getSavedJobs();

  void _listenToConnectivity() {
    _connectivity.onConnectivityChanged.listen((isOnline) {
      _isOnline = isOnline;
      if (isOnline) {
        _onBackOnline();
      }
      notifyListeners();
    });
  }

  Future<void> _onBackOnline() async {
    await _repository.syncPendingData();
    await loadJobs(refresh: true);
  }

  Future<void> loadJobs({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _jobs.clear();
    }

    if (!_hasMore || _state == LoadingState.loading) return;

    _state = LoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await _repository.getJobs(
        page: _currentPage,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );

      if (fetched.isEmpty) {
        _hasMore = false;
      } else {
        if (refresh) {
          _jobs = fetched;
        } else {
          // Prevent duplicates
          final existingIds = _jobs.map((j) => j.id).toSet();
          _jobs.addAll(fetched.where((j) => !existingIds.contains(j.id)));
        }
        _currentPage++;
      }

      _applyFilters();
      _state = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = LoadingState.error;
    }

    notifyListeners();
  }

  Future<void> loadMoreJobs() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final fetched = await _repository.getJobs(page: _currentPage);
      if (fetched.isEmpty) {
        _hasMore = false;
      } else {
        final existingIds = _jobs.map((j) => j.id).toSet();
        _jobs.addAll(fetched.where((j) => !existingIds.contains(j.id)));
        _currentPage++;
      }
      _applyFilters();
    } catch (_) {}

    _isLoadingMore = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByLocation(String location) {
    _locationFilter = location;
    _applyFilters();
    notifyListeners();
  }

  void filterByType(String type) {
    _typeFilter = type;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _locationFilter = '';
    _typeFilter = '';
    _filteredJobs = [];
    notifyListeners();
  }

  void _applyFilters() {
    if (_searchQuery.isEmpty && _locationFilter.isEmpty && _typeFilter.isEmpty) {
      _filteredJobs = [];
      return;
    }
    _filteredJobs = _repository.searchLocal(
      query: _searchQuery,
      location: _locationFilter,
      employmentType: _typeFilter,
    );
  }

  Future<void> toggleSave(String jobId) async {
    await _repository.toggleSaveJob(jobId);
    final idx = _jobs.indexWhere((j) => j.id == jobId);
    if (idx >= 0) {
      _jobs[idx] = _jobs[idx].copyWith(isSaved: !_jobs[idx].isSaved);
    }
    _applyFilters();
    notifyListeners();
  }

  Future<void> applyToJob(Job job) async {
    await _repository.submitApplication(job);
    notifyListeners();
  }

  bool hasApplied(String jobId) => _repository.hasApplied(jobId);

  List<JobApplication> getApplications() => _repository.getAllApplications();

  Future<void> updateStatus(String appId, ApplicationStatus status) async {
    await _repository.updateApplicationStatus(appId, status);
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivity.dispose();
    _repository.dispose();
    super.dispose();
  }
}