import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/theme/app_theme.dart';
import 'package:task_management_system/providers/project_provider.dart';
import 'package:task_management_system/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
        title: 'نظام إدارة المهام',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const HomeScreen(),
      ),
    );
  }
}
