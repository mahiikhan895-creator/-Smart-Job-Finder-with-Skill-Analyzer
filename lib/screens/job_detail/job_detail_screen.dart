// lib/screens/job_detail/job_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/job_model.dart';
import '../../providers/job_provider.dart';
import '../../providers/skill_provider.dart';
import '../../utils/app_theme.dart';
import '../skill_analysis/skill_analysis_screen.dart';
import '../../database/local_database.dart';

class JobDetailScreen extends StatefulWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  @override
  void initState() {
    super.initState();
    LocalDatabase.instance.incrementJobView(widget.job.id);
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final hasApplied = jobProvider.hasApplied(widget.job.id);
    final job = widget.job;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(job, jobProvider),
          SliverToBoxAdapter(
            child: _buildBody(job, hasApplied, jobProvider),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(job, hasApplied, jobProvider),
    );
  }

  Widget _buildSliverAppBar(Job job, JobProvider provider) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppTheme.primary,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(
            job.isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: job.isSaved ? AppTheme.accent : Colors.white,
          ),
          onPressed: () => provider.toggleSave(job.id),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primary, Color(0xFF1A3A5C)],
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCompanyLogo(job),
                  const SizedBox(height: 12),
                  Text(
                    job.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job.company,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(Job job) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: job.logoUrl.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          job.logoUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildLogoFallback(job),
        ),
      )
          : _buildLogoFallback(job),
    );
  }

  Widget _buildLogoFallback(Job job) {
    return Center(
      child: Text(
        job.company.isNotEmpty ? job.company[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildBody(Job job, bool hasApplied, JobProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick info chips
          _buildInfoRow(job),
          const SizedBox(height: 20),

          // Salary
          _buildSection(
            title: '💰 Compensation',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FFF8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCCF5E4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payments_outlined, color: AppTheme.success),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      job.salaryRange,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Skills
          if (job.requiredSkills.isNotEmpty) ...[
            _buildSection(
              title: '🛠 Required Skills',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.requiredSkills
                    .map((s) => Chip(
                  label: Text(s),
                  backgroundColor: const Color(0xFFEEF2FF),
                  labelStyle: const TextStyle(
                    color: Color(0xFF4B6EF5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Skill Analysis Button
          _buildSkillAnalysisButton(),
          const SizedBox(height: 20),

          // Description
          _buildSection(
            title: '📋 Job Description',
            child: Text(
              job.description.isEmpty
                  ? 'No description available.'
                  : job.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildInfoRow(Job job) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _infoBadge(Icons.location_on_outlined, job.location),
        _infoBadge(Icons.work_outline, job.employmentType),
        _infoBadge(
          Icons.calendar_today_outlined,
          _formatDate(job.postedDate),
        ),
      ],
    );
  }

  Widget _infoBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildSkillAnalysisButton() {
    return GestureDetector(
      onTap: () {
        final skillProvider = context.read<SkillProvider>();
        skillProvider.clearAnalysis();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SkillAnalysisScreen(job: widget.job),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4B6EF5), Color(0xFF00D4FF)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4B6EF5).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.psychology_outlined, color: Colors.white, size: 28),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analyze Skills & Get Training',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'AI-powered skill extraction + course recommendations',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
      Job job, bool hasApplied, JobProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: hasApplied
                  ? null
                  : () async {
                await provider.applyToJob(job);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Application submitted!'),
                      backgroundColor: AppTheme.success,
                    ),
                  );
                  setState(() {});
                }
              },
              icon: Icon(
                  hasApplied ? Icons.check_circle : Icons.send_outlined),
              label: Text(hasApplied ? 'Applied' : 'Apply Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: hasApplied ? AppTheme.success : AppTheme.primary,
                disabledBackgroundColor: AppTheme.success,
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    if (diff < 30) return '${diff ~/ 7}w ago';
    return '${diff ~/ 30}mo ago';
  }
}