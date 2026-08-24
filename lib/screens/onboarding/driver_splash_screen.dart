import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/country_meat_logo.dart';

class DriverSplashScreen extends StatefulWidget {
  const DriverSplashScreen({super.key});

  @override
  State<DriverSplashScreen> createState() => _DriverSplashScreenState();
}

class _DriverSplashScreenState extends State<DriverSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFE53935),
      body: Center(
        child: CountryMeatLogo(
          isRed: false,
          fontSize: 44,
        ),
      ),
    );
  }
}
