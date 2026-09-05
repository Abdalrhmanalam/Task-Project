import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/models/models.dart';
import 'package:task_management_system/providers/project_provider.dart';
import 'package:task_management_system/theme/app_theme.dart';
import 'package:task_management_system/screens/project_form_screen.dart';
import 'package:task_management_system/screens/kanban_board_screen.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Consumer<ProjectProvider>(
          builder: (context, projectProvider, _) {
            if (_selectedIndex == 0) {
              return _buildDashboard(context, projectProvider);
            } else {
              return _buildProjectForm(context, projectProvider);
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'لوحة التحكم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'مشروع جديد',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, ProjectProvider provider) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نظام إدارة المهام',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'لوحة التحكم الرئيسية',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Projects List
          if (provider.projects.isEmpty)
            _buildEmptyState(context)
          else
            ...[
              Text(
                'المشاريع',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: AppTheme.spacing12),
              ...provider.projects.map((project) {
                final stats = provider.getProjectStats(project);
                return _buildProjectCard(context, project, stats);
              }),
            ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.inbox,
            size: 80,
            color: Colors.white30,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'لا توجد مشاريع',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'قم بإنشاء مشروع جديد للبدء',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project, ProjectStats stats) {
    return GestureDetector(
      onTap: () {
        context.read<ProjectProvider>().setCurrentProject(project);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const KanbanBoardScreen(),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.1),
                AppTheme.secondaryColor.withOpacity(0.1),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            project.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing12,
                        vertical: AppTheme.spacing8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadius8),
                      ),
                      child: Text(
                        '${stats.completionPercentage.toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing12),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                  child: LinearProgressIndicator(
                    value: stats.completionPercentage / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(
                      AppTheme.successColor,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing12),
                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(
                      icon: Icons.assignment,
                      label: 'المهام',
                      value: '${stats.totalTasks}',
                    ),
                    _buildStatItem(
                      icon: Icons.check_circle,
                      label: 'منتهية',
                      value: '${stats.completedTasks}',
                    ),
                    _buildStatItem(
                      icon: Icons.people,
                      label: 'الفريق',
                      value: '${project.members.length}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectForm(BuildContext context, ProjectProvider provider) {
    return const ProjectFormScreen();
  }
}
