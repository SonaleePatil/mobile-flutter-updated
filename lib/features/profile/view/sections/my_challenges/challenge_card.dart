import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String status;
  final String progressText;
  final double progress;
  final String daysLeft;
  final String participants;

  const ChallengeCard({
    super.key,
    this.title = 'December Distance Champion',
    this.description = 'Ride 500km this month to earn the champion badge',
    this.image = 'assets/images/cycling_1.png',
    this.status = 'Joined',
    this.progressText = '324 / 500 km',
    this.progress = 324 / 500,
    this.daysLeft = '12 days left',
    this.participants = '234',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 358,
        height: 334.4447,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEFD7),
          borderRadius: BorderRadius.circular(18.1252),
          border: Border.all(
            color: const Color(0xFFE6D5C3),
            width: 1.2885,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18.1252),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    width: 358,
                    height: 160,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),

                  
                  Container(
                    width: 358,
                    height: 160,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),

              
                  Positioned(
                    bottom: 14,
                    left: 16,
                    child: Text(
  title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: Colors.white,
  ),
)
                  ),

                
                 Positioned(
  top: 17,
  left: 14,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(999),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Container(
        width: 64,
        height: 26,
        padding: const EdgeInsets.fromLTRB(12, 3, 13, 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1C20).withOpacity(0.15),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  ),
)
                ],
              ),
            ),

         
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
  description,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: Color(0xFF343434),
  ),
),

                    const SizedBox(height: 16),

                    /// Progress Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
  "Progress",
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15.4727,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
    color: Color(0xFF5B5B5B),
  ),
),
                      Text(
  progressText,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15.4727,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
)
                      ],
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Color(0xFFE0E0E0),
                        valueColor:
                            AlwaysStoppedAnimation(Color(0xffCF9F0C)),
                      ),
                    ),

                   const SizedBox(height: 21),

                    /// Bottom Info Row
                   Row(
  children: [
    
    Row(
      children:  [
        Icon(
          Icons.access_time,
          size: 18,
          color: Color(0xffD32F2F),
        ),
        SizedBox(width: 6),
        Text(
      daysLeft,
      style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15.4727,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textDark.withValues(alpha: 0.6),
  ),
)
      ],
    ),

    const SizedBox(width: 20),

    Row(
      children:  [
        Icon(
          Icons.group_outlined,
          size: 18,
          color: Color(0xffD32F2F),
        ),
        SizedBox(width: 6),
          Text(
        participants,
        style:  TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15.4727,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textDark.withValues(alpha: 0.6),
  ),
)
      ],
    ),

    const Spacer(),


    const Icon(
      Icons.chevron_right,
      size: 22,
      color: Color(0xff9E9E9E),
    ),
  ],
),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}