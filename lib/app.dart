import 'package:flutter/material.dart';
import 'screens/home/home_page.dart';

class TimTroApp extends StatelessWidget {
  const TimTroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tim Tro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E40AF),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}
