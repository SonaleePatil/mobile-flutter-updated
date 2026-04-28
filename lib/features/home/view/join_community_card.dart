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
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 135,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFCF9F0C),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/home1.png',
                  width: 175,
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
                        Color(0xFFF3BF10),
                        Color(0xD8CF9F0C),
                        Color(0x00CF9F0C),
                      ],
                      stops: [0.0, 0.58, 1.0],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Want to join rides or be\npart of the community?',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 37 / 2,
                        height: 1.25,
                      ),
                    ),
                    const Spacer(),
                    AppButton(
                      label: 'Join ADCC',
                      width: 162,
                      height: 44,
                      borderRadius: 50,
                      textStyle: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 33 / 2,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                        color: Colors.white,
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
