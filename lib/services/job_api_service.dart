// lib/services/job_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';

/// API 1 – Job Listings API
/// Uses Remotive.io free public jobs API (no key required)
class JobApiService {
  static const String _baseUrl = 'https://remotive.com/api/remote-jobs';
  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;

  JobApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch jobs with optional filtering
  Future<List<Job>> fetchJobs({
    String? category,
    String? search,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);
      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final jobs = (data['jobs'] as List? ?? [])
            .map((j) => _mapRemotiveJob(j))
            .toList();
        // Apply offset manually
        if (offset < jobs.length) {
          return jobs.skip(offset).take(limit).toList();
        }
        return jobs;
      } else {
        throw ApiException(
            'Failed to fetch jobs: ${response.statusCode}', response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e', 0);
    }
  }

  /// Map Remotive API response to Job model
  Job _mapRemotiveJob(Map<String, dynamic> json) {
    return Job(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Unknown Title',
      company: json['company_name'] ?? 'Unknown Company',
      location: json['candidate_required_location'] ?? 'Remote',
      employmentType: json['job_type'] ?? 'Full-time',
      salaryRange: _parseSalary(json),
      description: _stripHtml(json['description'] ?? ''),
      requiredSkills: _extractTags(json),
      logoUrl: json['company_logo'] ?? '',
      postedDate: DateTime.tryParse(json['publication_date'] ?? '') ?? DateTime.now(),
    );
  }

  String _parseSalary(Map<String, dynamic> json) {
    final salary = json['salary'];
    if (salary != null && salary.toString().isNotEmpty) return salary.toString();
    return 'Competitive';
  }

  List<String> _extractTags(Map<String, dynamic> json) {
    final tags = json['tags'] as List? ?? [];
    return tags.map((t) => t.toString()).take(8).toList();
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  void dispose() => _client.close();
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}