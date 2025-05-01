import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFBFD7ED),
      child: Center(
        child: Image.asset(
          'assets/icons/app_icon_main_new.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }
} 