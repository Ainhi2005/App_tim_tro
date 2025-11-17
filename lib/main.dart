import 'package:app_tim_tro/screens/home/widgets/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/viewModel/auth_viewmodel.dart';

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo SharedPreferences
  await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        // Thêm các provider khác nếu cần
      ],
      child: MaterialApp(
        title: 'Your App',
        home: LoginPage(),
      ),
    );
  }
}
