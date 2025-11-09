import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home/home_page.dart';

class TimTroApp extends StatelessWidget {
  const TimTroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Tìm Trọ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
