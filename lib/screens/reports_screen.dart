import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:task_management_system/models/models.dart';
import 'package:task_management_system/providers/project_provider.dart';
import 'package:task_management_system/theme/app_theme.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير والإحصائيات'),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, _) {
          final project = provider.currentProject;
          if (project == null) {
            return const Center(child: Text('لا يوجد مشروع محدد'));
          }

          final stats = provider.getProjectStats(project);

          return Container(
            decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCards(context, stats),
                  const SizedBox(height: AppTheme.spacing24),
                  _buildProgressChart(context, stats),
                  const SizedBox(height: AppTheme.spacing24),
                  _buildTeamStats(context, stats),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, ProjectStats stats) {
    return Column(
      children: [
        _buildStatCard(
          title: 'إجمالي المهام',
          value: '${stats.totalTasks}',
          icon: Icons.assignment,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: AppTheme.spacing12),
        _buildStatCard(
          title: 'المهام المنجزة',
          value: '${stats.completedTasks}',
          icon: Icons.check_circle,
          color: AppTheme.successColor,
        ),
        const SizedBox(height: AppTheme.spacing12),
        _buildStatCard(
          title: 'نسبة الإنجاز',
          value: '${stats.completionPercentage.toStringAsFixed(1)}%',
          icon: Icons.percent,
          color: AppTheme.infoColor,
        ),
        const SizedBox(height: AppTheme.spacing12),
        _buildStatCard(
          title: 'إجمالي الساعات المتوقعة',
          value: '${stats.totalEstimatedHours.toStringAsFixed(1)}',
          icon: Icons.schedule,
          color: AppTheme.warningColor,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadius12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressChart(BuildContext context, ProjectStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'توزيع المهام حسب الحالة',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: (stats.tasksByStatus[TaskStatus.neu] ?? 0)
                          .toDouble(),
                      title: 'جديد',
                      color: AppTheme.newStatusColor,
                    ),
                    PieChartSectionData(
                      value: (stats.tasksByStatus[TaskStatus.inProgress] ?? 0)
                          .toDouble(),
                      title: 'قيد العمل',
                      color: AppTheme.inProgressStatusColor,
                    ),
                    PieChartSectionData(
                      value: (stats.tasksByStatus[TaskStatus.completed] ?? 0)
                          .toDouble(),
                      title: 'منتهي',
                      color: AppTheme.completedStatusColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamStats(BuildContext context, ProjectStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات الفريق',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing16),
            ...stats.memberStats.map((member) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(member.memberName),
                        Text(
                          '${member.completionRate.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadius8),
                      child: LinearProgressIndicator(
                        value: member.completionRate / 100,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
