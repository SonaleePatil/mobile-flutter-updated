import 'package:adcc/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

class JoinCommunityCard extends StatelessWidget {
  final VoidCallback onJoinTap;

  const JoinCommunityCard({super.key, required this.onJoinTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF035AE9),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/home1.png',
                  width: 194,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF035AE9),
                        Color(0xE6035AE9),
                        Color(0x00035AE9),
                      ],
                      stops: [0.0, 0.58, 1.0],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(19, 15, 19, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Want to join rides or be\npart of the community?',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    AppButton(
                      label: 'Join ADCC',
                      width: 112,
                      height: 32,
                      borderRadius: 50,
                      backgroundColor: const Color(0xFFFFC825),
                      textStyle: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                        color: Colors.black,
                      ),
                      onPressed: onJoinTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
