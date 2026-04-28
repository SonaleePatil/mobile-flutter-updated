import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
class CommunityListCard extends StatelessWidget {
  final CommunityModel community;
  final VoidCallback? onTap;

  const CommunityListCard({
    super.key,
    required this.community,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 358,
      height: 286,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11.5872),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.dustyRose,
              borderRadius: BorderRadius.circular(11.5872),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  width: 358,
                  height: 178.6592,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.4581),
                        child: Image.network(
                          community.imageUrl ?? '',
                          width: 358,
                          height: 178.6592,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Image.asset(
                              "assets/images/cycling_1.png",
                              width: 358,
                              height: 178.6592,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),

                    

Positioned(
  left: 12,
  top: 13,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(100),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Container(
        height: 24,
        constraints: const BoxConstraints(minWidth: 60),
        padding: const EdgeInsets.only(
          top: 4,
          right: 8,
          bottom: 4,
          left: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1C20).withOpacity(0.33),
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text(
  community.category.isNotEmpty
      ? community.category.first
      : "Racing",
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33, // 16px / 12px = 1.33 line height
    letterSpacing: 0,
    color: Color(0xFFFFEFD7),
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
                    padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Text(
  community.title,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),

                        const SizedBox(height: 5),

               
                        Text(
  community.description,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.16, // 13.9441 / 12 ≈ 1.16
    letterSpacing: 0,
    color: AppColors.textDark.withValues(alpha: 0.7), // textDark 70%
  ),
),

                        const Spacer(),


                      Row(
  children: [
    Image.asset(
      "assets/icons/person_sharp.png",
      width: 15,
      height: 15,
      color: AppColors.charcoal.withValues(alpha: 0.70),
    ),
    const SizedBox(width: 6),
   Text(
  '${community.membersCount ?? 0} members',
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.42, // 17.0968 / 12 ≈ 1.42
    letterSpacing: 0,
    color: Color(0xFF484A4D),
  ),
),
    const SizedBox(width: 14),

    Image.asset(
      "assets/icons/calender.png",
      width: 15,
      height: 15,
      color: AppColors.charcoal.withValues(alpha: 0.70),
    ),
    const SizedBox(width: 6),
Text(
  '${community.eventsCount ?? 0} events',
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.42, // 17.0968 / 12 ≈ 1.42
    letterSpacing: 0,
    color: Color(0xFF484A4D),
  ),
),

    const Spacer(),

    const _AvatarStack(countText: "+456"),
  ],
)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  final String countText;

  const _AvatarStack({
    required this.countText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 55,
          height: 25,
          child: Stack(
            children: const [
              _AvatarCircle(left: 0, imagePath: "assets/images/cycling_1.png"),
              _AvatarCircle(left: 14, imagePath: "assets/images/cycling_1.png"),
              _AvatarCircle(left: 28, imagePath: "assets/images/cycling_1.png"),
            ],
          ),
        ),
        const SizedBox(width: 6),
      Text(
  countText,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.42, // 17.0968 / 12 ≈ 1.42
    letterSpacing: 0,
    color: Color(0XFF484A4D),
  ),
),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final double left;
  final String imagePath;

  const _AvatarCircle({
    required this.left,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        height: 25,
        width: 25,
       
        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
