import 'package:flutter/material.dart';
import 'package:coolapp/constants/colors.dart';
import 'package:coolapp/app/router.dart';
import 'package:coolapp/screens/login/login_screen.dart';

void main() {
  runApp(const StaffClockApp());
}

class StaffClockApp extends StatelessWidget {
  const StaffClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StaffClock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
