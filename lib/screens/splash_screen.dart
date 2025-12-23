import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // --- MAIN DIAGONAL GRADIENT BG (matches your mockup) ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF6A5BFF),   // top-left bluish
                  Color(0xFF9A63FF),   // mid purple
                  Color(0xFFE47CEB),   // bottom-right pinkish
                ],
              ),
            ),
          ),

          // --- UNION OVERLAY PNG ---
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/Union.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // --- CENTER CONTENT ---
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // --- SPLASH ICON PNG ---
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "assets/splash_icon.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  "TaskFlow",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
