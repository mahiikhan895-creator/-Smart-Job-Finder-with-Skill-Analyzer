// lib/repositories/skill_repository.dart
import '../models/skill_model.dart';
import '../services/skill_api_service.dart';
import '../services/skill_extractor_service.dart';
import '../database/local_database.dart';

class SkillRepository {
  final SkillApiService _apiService;
  final SkillExtractorService _extractor;
  final LocalDatabase _db;

  SkillRepository({
    SkillApiService? apiService,
    SkillExtractorService? extractor,
    LocalDatabase? db,
  })  : _apiService = apiService ?? SkillApiService(),
        _extractor = extractor ?? SkillExtractorService(),
        _db = db ?? LocalDatabase.instance;

  /// Analyze a job description and return skills with training data
  Future<Map<SkillCategory, List<Skill>>> analyzeJobDescription(
      String description) async {
    // Step 1: Extract skills from description
    final categorizedNames = _extractor.extractSkills(description);

    // Step 2: Get training data for each skill
    final allSkillNames = [
      ...?categorizedNames[SkillCategory.technical],
      ...?categorizedNames[SkillCategory.soft],
    ];

    // Step 3: Check local cache first
    final cachedSkills = _db.getSkillsForNames(allSkillNames);
    final cachedNames = cachedSkills.map((s) => s.name.toLowerCase()).toSet();
    final missingNames =
    allSkillNames.where((n) => !cachedNames.contains(n.toLowerCase())).toList();

    // Step 4: Fetch missing skills from API
    List<Skill> fetchedSkills = [];
    if (missingNames.isNotEmpty) {
      try {
        fetchedSkills = await _apiService.fetchSkillsForNames(missingNames);
        await _db.saveSkills(fetchedSkills);
      } catch (_) {
        // If offline, use fallback
        fetchedSkills = missingNames.map((name) {
          final allSkills = _db.getAllSkills();
          return allSkills.firstWhere(
                (s) => s.name.toLowerCase() == name.toLowerCase(),
            orElse: () => Skill(
              id: name.hashCode.toString(),
              name: name,
              category: _inferCategory(name, categorizedNames),
              recommendedCourse: 'Self-study recommended',
              difficultyLevel: 'Beginner',
            ),
          );
        }).toList();
      }
    }

    final allSkills = [...cachedSkills, ...fetchedSkills];

    // Step 5: Re-categorize based on extracted info
    return {
      SkillCategory.technical: allSkills
          .where((s) =>
      categorizedNames[SkillCategory.technical]
          ?.map((n) => n.toLowerCase())
          .contains(s.name.toLowerCase()) ??
          false)
          .toList(),
      SkillCategory.soft: allSkills
          .where((s) =>
      categorizedNames[SkillCategory.soft]
          ?.map((n) => n.toLowerCase())
          .contains(s.name.toLowerCase()) ??
          false)
          .toList(),
      SkillCategory.other: allSkills
          .where((s) => s.category == 'Other')
          .toList(),
    };
  }

  String _inferCategory(
      String name, Map<SkillCategory, List<String>> categorized) {
    if (categorized[SkillCategory.technical]
        ?.map((n) => n.toLowerCase())
        .contains(name.toLowerCase()) ??
        false) {
      return 'Technical';
    }
    if (categorized[SkillCategory.soft]
        ?.map((n) => n.toLowerCase())
        .contains(name.toLowerCase()) ??
        false) {
      return 'Soft';
    }
    return 'Other';
  }

  List<Skill> getCachedSkills() => _db.getAllSkills();

  void dispose() => _apiService.dispose();
}