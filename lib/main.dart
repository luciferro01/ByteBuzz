import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/features/auth/view/signup_view.dart';
import 'package:x_clone/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Clone',
      theme: AppTheme.theme,
      home: const SignUpView(),
    );
  }
}
