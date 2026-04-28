import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RecentlyPost extends StatelessWidget {
  const RecentlyPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// SECTION HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Text(
  "Recently Posted",
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                   Text(
  "View All",
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: Color(0xFF484A4D),
  ),
),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 18,color:Color(0xFF484A4D) ,)
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          /// CARD LIST
          SizedBox(
            height: 253,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                RecentlyPostCard(),
                SizedBox(width: 16),
                RecentlyPostCard(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RecentlyPostCard extends StatelessWidget {
  const RecentlyPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172,
      height: 253,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE + SHARE BUTTON
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  "assets/images/bike.png",
                  width: 172,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.share,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TITLE
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
  "Trek Domane",
  style: TextStyle(
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
          ),

          const SizedBox(height: 1),

        /// POSTED BY
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8),
  child: RichText(
    text: TextSpan(
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
      ),
      children: [
        TextSpan(
          text: "Posted by ",
          style: TextStyle(
            color: const Color(0xFF1A1C20).withOpacity(0.6), // light
          ),
        ),
        const TextSpan(
          text: "Mahmoud shaalan",
          style: TextStyle(
            color: Color(0xFF1A1C20), // dark
          ),
        ),
      ],
    ),
  ),
),

          const SizedBox(height: 6),

        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
  "7500 AED",
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.deepRed,
  ),
),
          ),
        ],
      ),
    );
  }
}