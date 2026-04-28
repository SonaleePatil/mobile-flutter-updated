import 'package:flutter/material.dart';

class ShareAchievementsButton extends StatelessWidget {
  const ShareAchievementsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: 358,
        height: 51,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC12D32),
            elevation: 0,
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/share_2.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                color: Colors.white,
              ),
              const SizedBox(width: 7.2443),
             Text(
  "Share My Achievements",
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14.5157,
    fontWeight: FontWeight.w400,
    height: 21.7735 / 14.5157, // ≈1.5
    letterSpacing: 0,
    color: Colors.white,
  ),
)
            ],
          ),
        ),
      ),
    );
  }
}