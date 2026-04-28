import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
class MyCommunitiesSection extends StatelessWidget {
  const MyCommunitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.softCream,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
               Text(
  "My Communities",
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
                Row(
                  children: [
                   Text(
  "View All",
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14, // ≈1.43
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.charcoal,
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

 
          SizedBox(
        
           height: 273,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return const _CommunityCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 328,
      height: 273,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.5872),
        child: Container(
          color: const Color(0xFFFFEFD7),
          child: Column(
            children: [

      
              SizedBox(
                width: 358,
                height: 178.6592,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.4581),
                    topRight: Radius.circular(10.4581),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [

                      /// IMAGE
                      Image.asset(
                        "assets/images/cycling_1.png",
                        fit: BoxFit.cover,
                      ),

                      /// Overlay
                      Container(
                        color: Colors.black.withOpacity(0.10),
                      ),

                  Positioned(
  top: 13,
  left: 12,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(999),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: Container(
        height: 24,
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1C20).withOpacity(0.33),
          borderRadius: BorderRadius.circular(999),
        ),
        child:const Text(
  "Joined",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12, // ≈1.33
    letterSpacing: 0,
    color: AppColors.softCream,
  ),
)
      ),
    ),
  ),
)
                    ],
                  ),
                ),
              ),

           
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text(
  "Abu Dhabi Road Racers",
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15.6872,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
                      SizedBox(height: 4),
                     Text(
  "Weekly high-pace road rides & race training",
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style:  TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10.4581,
    fontWeight: FontWeight.w400,
    height: 13.9441 / 10.4581, // ≈1.33
    letterSpacing: 0,
   color: AppColors.textDark.withOpacity(0.7),
  ),
),
                      Spacer(),
                      Row(
                        children: [
                         Image.asset(
  "assets/icons/person_sharp.png",
  width: 15,
  height: 13,
  color: AppColors.textDark,
  fit: BoxFit.contain,
),
                          SizedBox(width: 8),
Text(
  "2,800 members",
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12, // ≈1.33
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}