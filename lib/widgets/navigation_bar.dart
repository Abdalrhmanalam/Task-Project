import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'لوحة التحكم',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'المهام',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'الفريق',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'التقارير',
        ),
      ],
    );
  }
}
