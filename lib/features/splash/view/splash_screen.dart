import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a solid backdrop so transparent areas in the Lottie don't show white.
      backgroundColor: AppColors.softCream,
      body: SizedBox.expand(
        child: Lottie.asset(
          'assets/lotties/splash_screen_2.json',
          fit: BoxFit.cover, // cover to avoid blank edges
          delegates: LottieDelegates(
            values: [
              // Hide the baked-in white texture layer ("Clean_White (1).jpg") to avoid white spots.
              ValueDelegate.opacity(
                const ['**', 'Clean_White (1).jpg', '**', 'Opacity'],
                value: 0,
              ),
            ],
          ),
          onLoaded: (composition) {
            Future.delayed(composition.duration, _goNext);
          },
        ),
      ),
    );
  }
}

