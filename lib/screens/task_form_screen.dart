import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uuid/uuid.dart';
import 'package:task_management_system/models/models.dart';
import 'package:task_management_system/providers/project_provider.dart';
import 'package:task_management_system/theme/app_theme.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _estimatedHoursController;
  DateTime? _dueDate;
  Priority? _selectedPriority;
  TaskStatus? _selectedStatus;
  String? _selectedAssignee;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _estimatedHoursController = TextEditingController(
      text: widget.task?.estimatedHours.toString() ?? '',
    );
    _dueDate = widget.task?.dueDate;
    _selectedPriority = widget.task?.priority ?? Priority.medium;
    _selectedStatus = widget.task?.status ?? TaskStatus.neu;
    _selectedAssignee = widget.task?.assignedTo;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedHoursController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submitForm() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _dueDate == null ||
        _selectedAssignee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء ملء جميع الحقول')),
      );
      return;
    }

    final provider = context.read<ProjectProvider>();
    final project = provider.currentProject;

    if (project == null) return;

    final task = Task(
      id: widget.task?.id ?? const Uuid().v4(),
      projectId: project.id,
      title: _titleController.text,
      description: _descriptionController.text,
      priority: _selectedPriority ?? Priority.medium,
      status: _selectedStatus ?? TaskStatus.neu,
      dueDate: _dueDate!,
      assignedTo: _selectedAssignee!,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      estimatedHours: double.tryParse(_estimatedHoursController.text) ?? 0,
      statusHistory: widget.task?.statusHistory ?? [],
    );

    if (widget.task == null) {
      provider.addTask(task);
    } else {
      provider.updateTask(task);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'مهمة جديدة' : 'تعديل المهمة'),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('العنوان', _titleController, Icons.title),
                  const SizedBox(height: AppTheme.spacing16),
                  _buildTextField('الوصف', _descriptionController,
                      Icons.description,
                      maxLines: 3),
                  const SizedBox(height: AppTheme.spacing16),
                  _buildTextField(
                    'الساعات المتوقعة',
                    _estimatedHoursController,
                    Icons.schedule,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  _buildPriorityDropdown(),
                  const SizedBox(height: AppTheme.spacing16),
                  _buildStatusDropdown(),
                  const SizedBox(height: AppTheme.spacing16),
                  _buildAssigneeDropdown(),
                  const SizedBox(height: AppTheme.spacing16),
                  _buildDatePicker(),
                  const SizedBox(height: AppTheme.spacing24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Padding(
                        padding: EdgeInsets.all(AppTheme.spacing12),
                        child: Text('حفظ المهمة'),
                      ),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppTheme.spacing8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الأولوية', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppTheme.spacing8),
        DropdownButton<Priority>(
          value: _selectedPriority,
          isExpanded: true,
          items: Priority.values.map((priority) {
            return DropdownMenuItem(
              value: priority,
              child: Text(_getPriorityLabel(priority)),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedPriority = value),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الحالة', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppTheme.spacing8),
        DropdownButton<TaskStatus>(
          value: _selectedStatus,
          isExpanded: true,
          items: TaskStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(_getStatusLabel(status)),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedStatus = value),
        ),
      ],
    );
  }

  Widget _buildAssigneeDropdown() {
    return Consumer<ProjectProvider>(
      builder: (context, provider, _) {
        final members = provider.currentProject?.members ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المسؤول', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppTheme.spacing8),
            DropdownButton<String>(
              value: _selectedAssignee,
              isExpanded: true,
              items: members.map((member) {
                return DropdownMenuItem(
                  value: member.id,
                  child: Text(member.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedAssignee = value),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تاريخ التسليم', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppTheme.spacing8),
        ElevatedButton.icon(
          onPressed: _selectDate,
          icon: const Icon(Icons.calendar_today),
          label: Text(
            _dueDate == null
                ? 'اختر التاريخ'
                : intl.DateFormat('yyyy-MM-dd').format(_dueDate!),
          ),
        ),
      ],
    );
  }

  String _getPriorityLabel(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'عالية';
      case Priority.medium:
        return 'متوسطة';
      case Priority.low:
        return 'منخفضة';
    }
  }

  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.neu:
        return 'جديد';
      case TaskStatus.inProgress:
        return 'قيد العمل';
      case TaskStatus.completed:
        return 'منتهي';
    }
  }
}
