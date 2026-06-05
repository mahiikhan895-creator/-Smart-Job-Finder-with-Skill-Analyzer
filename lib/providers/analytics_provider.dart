// lib/providers/analytics_provider.dart
import 'package:flutter/foundation.dart';
import '../database/local_database.dart';

class AnalyticsData {
  final int totalViews;
  final int totalSaved;
  final int totalApplications;
  final Map<String, int> statusDistribution;
  final String mostCommonSkillCategory;
  final String mostRecommendedCourse;

  const AnalyticsData({
    required this.totalViews,
    required this.totalSaved,
    required this.totalApplications,
    required this.statusDistribution,
    required this.mostCommonSkillCategory,
    required this.mostRecommendedCourse,
  });
}

class AnalyticsProvider extends ChangeNotifier {
  final LocalDatabase _db;
  AnalyticsData? _data;

  AnalyticsProvider({LocalDatabase? db}) : _db = db ?? LocalDatabase.instance;

  AnalyticsData? get data => _data;

  void refresh() {
    _data = AnalyticsData(
      totalViews: _db.getTotalViews(),
      totalSaved: _db.getTotalSaved(),
      totalApplications: _db.getTotalApplications(),
      statusDistribution: _db.getStatusDistribution(),
      mostCommonSkillCategory: _db.getMostCommonSkillCategory(),
      mostRecommendedCourse: _db.getMostRecommendedCourse(),
    );
    notifyListeners();
  }
}