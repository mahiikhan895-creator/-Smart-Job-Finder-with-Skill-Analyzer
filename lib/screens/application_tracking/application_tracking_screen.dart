// lib/screens/application_tracking/application_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/application_model.dart';
import '../../providers/job_provider.dart';
import '../../utils/app_theme.dart';
import 'package:intl/intl.dart';

class ApplicationTrackingScreen extends StatefulWidget {
  const ApplicationTrackingScreen({super.key});

  @override
  State<ApplicationTrackingScreen> createState() =>
      _ApplicationTrackingScreenState();
}

class _ApplicationTrackingScreenState
    extends State<ApplicationTrackingScreen> {
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('My Applications'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<JobProvider>(
        builder: (context, provider, _) {
          final apps = provider.getApplications();
          final filtered = _statusFilter == 'All'
              ? apps
              : apps
              .where((a) =>
          a.applicationStatus.label == _statusFilter)
              .toList();

          return Column(
            children: [
              _buildFilterRow(apps),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmpty()
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildApplicationCard(
                          filtered[index], provider),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterRow(List<JobApplication> apps) {
    final statuses = ['All', 'Applied', 'Interview Scheduled', 'Rejected', 'Accepted'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: statuses.map((s) {
            final count = s == 'All'
                ? apps.length
                : apps
                .where((a) => a.applicationStatus.label == s)
                .length;
            final isSelected = _statusFilter == s;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _statusFilter = s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.divider,
                    ),
                  ),
                  child: Text(
                    '$s ($count)',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(
      JobApplication app, JobProvider provider) {
    final statusColor = AppTheme.statusColor(app.status);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.jobTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        app.company,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    app.applicationStatus.label,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 13, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Applied: ${DateFormat('MMM d, yyyy').format(app.appliedDate)}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  'Updated: ${DateFormat('MMM d').format(app.updatedDate)}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            const Text(
              'Update Status:',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            _buildStatusRow(app, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(JobApplication app, JobProvider provider) {
    final statuses = [
      ApplicationStatus.applied,
      ApplicationStatus.interviewScheduled,
      ApplicationStatus.rejected,
      ApplicationStatus.accepted,
    ];
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: statuses.map((s) {
        final isActive = app.applicationStatus == s;
        final color = AppTheme.statusColor(s.value);
        return GestureDetector(
          onTap: isActive
              ? null
              : () async {
            await provider.updateStatus(app.id, s);
            setState(() {});
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isActive ? color : color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isActive ? color : color.withOpacity(0.3)),
            ),
            child: Text(
              s.label,
              style: TextStyle(
                color: isActive ? Colors.white : color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppTheme.textSecondary),
          SizedBox(height: 16),
          Text(
            'No applications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Apply to jobs to track them here',
            style:
            TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}