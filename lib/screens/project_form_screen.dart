import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uuid/uuid.dart';
import 'package:task_management_system/models/models.dart';
import 'package:task_management_system/providers/project_provider.dart';
import 'package:task_management_system/theme/app_theme.dart';

class ProjectFormScreen extends StatefulWidget {
  const ProjectFormScreen({Key? key}) : super(key: key);

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء تحديد التاريخ')),
        );
        return;
      }

      final project = Project(
        id: const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        createdAt: DateTime.now(),
        tasks: [],
      );

      context.read<ProjectProvider>().addProject(project);

      _nameController.clear();
      _descriptionController.clear();
      setState(() {
        _startDate = null;
        _endDate = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء المشروع بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إنشاء مشروع جديد',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacing24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اسم المشروع',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'أدخل اسم المشروع',
                        prefixIcon: const Icon(Icons.business),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.borderRadius12),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'الرجاء إدخال اسم المشروع';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    Text(
                      'وصف المشروع',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'أدخل وصف المشروع',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.borderRadius12),
                        ),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'الرجاء إدخال وصف المشروع';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    Text(
                      'تاريخ البداية',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    ElevatedButton.icon(
                      onPressed: () => _selectDate(context, true),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _startDate == null
                            ? 'اختر التاريخ'
                            : intl.DateFormat('yyyy-MM-dd').format(_startDate!),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    Text(
                      'تاريخ النهاية',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    ElevatedButton.icon(
                      onPressed: () => _selectDate(context, false),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _endDate == null
                            ? 'اختر التاريخ'
                            : intl.DateFormat('yyyy-MM-dd').format(_endDate!),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Padding(
                          padding: EdgeInsets.all(AppTheme.spacing12),
                          child: Text(
                            'إنشاء المشروع',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
