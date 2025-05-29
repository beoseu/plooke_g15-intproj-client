import 'package:flutter/material.dart';
import 'package:frontend/pages/user/homepage.dart';
import 'package:frontend/pages/planter/orderpage.dart';
import 'package:frontend/pages/auth/signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFF7F7F7)),
      home: Scaffold(body: SignInPage()),
    );
  }
}
