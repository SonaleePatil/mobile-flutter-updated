import 'package:flutter/material.dart';

class PromoData {
  final String image;
  final String title;
  final String subtitle;
  final String highlight;
  final String buttonText;

  PromoData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.highlight,
    required this.buttonText,
  });
}

class PromoCard extends StatelessWidget {
  final PromoData data;

  const PromoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              data.image,
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
                    Colors.black87,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: -25,
            right: -25,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 10,
                  color: Color(0xFFF2B705),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

               Text(
  data.title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 23.2228,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Colors.white,
  ),
),

                const Spacer(),

              Text(
  data.subtitle,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    height: 1.31,
    letterSpacing: 0,
    color: Colors.white70,
  ),
),
                const SizedBox(height: 2),

                Row(
                  children: [

                  Expanded(
  child: Text(
    data.highlight,
    style: const TextStyle(
      fontFamily: 'Outfit',
      fontSize: 16.6667,
      fontWeight: FontWeight.w700,
      height: 1.31,
      letterSpacing: 0,
      color: Colors.white,
    ),
  ),
),

                    Container(
                      width: 99,
                      height: 28.5,

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9EF),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Center(
                        child: Text(
  "Find a ride",
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
    color: Color(0xFFC12D32),
  ),
)
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}