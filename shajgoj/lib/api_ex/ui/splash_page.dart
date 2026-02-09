import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shajgoj/api_ex/services/auth_service.dart';
import 'package:shajgoj/api_ex/ui/login_page.dart';
import 'package:shajgoj/api_ex/ui/product_list_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  void _startSplash() async {
    // Splash delay
    await Future.delayed(const Duration(seconds: 1));

    final token = await authService.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductListPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // change if needed
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Logo
            Image.asset('assets/images/logo.png', width: 120, height: 120),

            const SizedBox(height: 20),

            // Loader
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:ay_app/api_ex/services/auth_service.dart';
// import 'package:ay_app/api_ex/ui/login_page.dart';
// import 'package:ay_app/api_ex/ui/product_list_page.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   final AuthService authService = AuthService();

//   @override
//   void initState() {
//     super.initState();
//     checkLogin();
//   }

//   void checkLogin() async {
//     final token = await authService.getToken();

//     // if (!mounted) return;

//     if (token != null && token.isNotEmpty) {
//       // User already logged in
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const ProductListPage()),
//       );
//     } else {
//       // Not logged in
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
