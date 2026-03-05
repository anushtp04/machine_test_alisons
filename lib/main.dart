import 'package:flutter/material.dart';
import 'package:machine_test_alisons/screens/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Machine Test',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const LoginPage(),
    );
  }
}

