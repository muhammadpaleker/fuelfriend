import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const FuelFriendApp());
}

class FuelFriendApp extends StatelessWidget {
  const FuelFriendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelFriend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005BB0)),
        fontFamily: 'Inter',
      ),
      home: const LoginScreen(),
    );
  }
}
