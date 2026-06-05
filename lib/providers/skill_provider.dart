// lib/providers/skill_provider.dart
import 'package:flutter/foundation.dart';
import '../models/skill_model.dart';
import '../repositories/skill_repository.dart';

class SkillProvider extends ChangeNotifier {
  final SkillRepository _repository;

  SkillProvider({SkillRepository? repository})
      : _repository = repository ?? SkillRepository();

  bool _isLoading = false;
  Map<SkillCategory, List<Skill>> _analyzedSkills = {};
  String? _errorMessage;
  String _currentJobId = '';

  bool get isLoading => _isLoading;
  Map<SkillCategory, List<Skill>> get analyzedSkills => _analyzedSkills;
  String? get errorMessage => _errorMessage;

  List<Skill> get technicalSkills =>
      _analyzedSkills[SkillCategory.technical] ?? [];
  List<Skill> get softSkills => _analyzedSkills[SkillCategory.soft] ?? [];
  List<Skill> get otherSkills => _analyzedSkills[SkillCategory.other] ?? [];
  int get totalSkillCount =>
      technicalSkills.length + softSkills.length + otherSkills.length;

  Future<void> analyzeJob(String jobId, String description) async {
    if (_currentJobId == jobId && _analyzedSkills.isNotEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    _currentJobId = jobId;
    notifyListeners();

    try {
      _analyzedSkills = await _repository.analyzeJobDescription(description);
    } catch (e) {
      _errorMessage = 'Failed to analyze skills: $e';
      _analyzedSkills = {};
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearAnalysis() {
    _analyzedSkills = {};
    _currentJobId = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}