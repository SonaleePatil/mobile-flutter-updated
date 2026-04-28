import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/my_community_screen.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:adcc/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JoinCommunity extends StatefulWidget {
  final CommunityModel community;

  const JoinCommunity({
    super.key,
    required this.community,
  });

  @override
  State<JoinCommunity> createState() => _JoinCommunityState();
}

class _JoinCommunityState extends State<JoinCommunity> {
  late CommunityModel _community;

  @override
  void initState() {
    super.initState();
    _community = widget.community;
    

  }

  @override
  Widget build(BuildContext context) {
    final title = _community.title.trim().isEmpty
        ? "Abu Dhabi Road Racers"
        : _community.title.trim();

    final members = _community.membersCount ?? 2800;
    final location = (_community.location ?? "Abu Dhabi").trim();

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final w = constraints.maxWidth;

            /// Responsive position for frame
            final frameTop = h * 0.36; // 36% from top
            final frameLeft = -w * 0.04; // slight outside
            final frameWidth = w * 0.32; // responsive width

            return Stack(
              children: [
               
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  child: Column(
                    children: [
                      /// SCROLLABLE PART
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                         child: Stack(
    children: [

      /// FRAME (now scrolls with content)
      Positioned(
        left: frameLeft,
        top: frameTop,
        child: IgnorePointer(
          child: Image.asset(
            "assets/images/frame_1.png",
            width: frameWidth,
            fit: BoxFit.contain,
          ),
        ),
      ),

      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
                            /// TOP BACK BUTTON
Align(
  alignment: Alignment.centerLeft,
  child: GestureDetector(
    onTap: () => Navigator.pop(context, true),
    child: Container(
      height: 35,
      width: 35,
      padding: const EdgeInsets.fromLTRB(10, 10, 7.54, 9.46),
      decoration: BoxDecoration(
        color: const Color(0x5CC12D32), // #C12D325C
        borderRadius: BorderRadius.circular(53.8462),
      ),
      child: const Icon(
        Icons.arrow_back,
        size: 15,
        color: Color(0xFFC12D32),
      ),
    ),
  ),
),

                              const SizedBox(height: 18),

                           /// CENTER GIF
Center(
  child: Image.asset(
    "assets/icons/checkmark.gif",
    height: 128,
    width: 128,
    fit: BoxFit.contain,
  ),
),
                              const SizedBox(height: 12),

/// TITLE
const Text(
  "Welcome to the\nCommunity!",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

                              const SizedBox(height: 7),

                            /// SUBTITLE
Text(
  "You have successfully joined\n$title",
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

                              const SizedBox(height: 24),

                              /// COMMUNITY CARD
                              _JoinedCommunityCard(
                                title: title,
                                members: members,
                                location: location,
                                imageUrl: _community.imageUrl,
                              ),

                              const SizedBox(height: 18),

                             /// WHAT'S NEXT
const Text(
  "What's Next?",
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

                              const SizedBox(height: 12),

                              /// OPTIONS
                              _NextOptionTile(
                                 iconPath: "assets/images/notification_enable.png",
                                title: "Notifications Enabled",
                                onTap: () {
                                  // Navigate to notifications settings
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Notifications feature coming soon"),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              _NextOptionTile(
                              iconPath: "assets/images/whatsup.png",
                                title: "Join Community Chats",
                                onTap: () {
                                  // Navigate to community chats
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Chat feature coming soon"),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              _NextOptionTile(
                           iconPath: "assets/icons/add_calendar.png",
                                title: "Upcoming Events",
                                onTap: () {
                                  // Navigate to community events
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Events feature coming soon"),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 46),
                                  ],
      ),
    ],
  ),
),
                      ),

                  
                      AppButton(
                        label: "Start Exploring",
                        onPressed: () {
                        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => Mycommunity(
      myCommunities: [_community],
    ),
  ),
);
                        },
                        type: AppButtonType.primary,
                        backgroundColor: const Color(0xFFB11212),
                        textColor: Colors.white,
                        borderRadius: 16,
                        height: 52,
                    textStyle: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
  ),
 
),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _JoinedCommunityCard extends StatelessWidget {
  final String title;
  final int members;
  final String location;
  final String? imageUrl;

  const _JoinedCommunityCard({
    required this.title,
    required this.members,
    required this.location,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.buttonGuest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AdaptiveImage(
                    imagePath: imageUrl ?? "assets/images/cycling_1.png",
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                    placeholderColor: AppColors.softCream,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Text(
  title,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
                      const SizedBox(height: 6),
                     Text(
  "The main cycling community in\nAbu Dhabi, bringing together...",
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal.withValues(alpha: 0.6),
  ),
),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          Row(
  children: [
    Expanded(
      child: _MiniInfoBox(
        iconPath: "assets/icons/red_people.png",
        title: "Members",
        value: members.toString(),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: _MiniInfoBox(
        iconPath: "assets/icons/location.png",
        title: "Location",
        value: location,
      ),
    ),
  ],
)
          ],
        ),
      ),
    );
  }
}


class _MiniInfoBox extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;

  const _MiniInfoBox({
    required this.iconPath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.dustyRose,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            height: 16,
            width: 13,
            color: AppColors.deepRed,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
  title,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 10.89, 
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
                const SizedBox(height: 4),
              Text(
  value,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12.7, // 12.7012 ≈ 12.7
    fontWeight: FontWeight.w500,
    height: 1.43, // 18.1446 / 12.7012 ≈ 1.43
    letterSpacing: 0,
    color: AppColors.charcoal,
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

class _NextOptionTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const _NextOptionTile({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  bool get isSvg => iconPath.endsWith(".svg");
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEFD7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height:54 ,
              width: 54,
              decoration: BoxDecoration(
                color: AppColors.goldenOchre,
                borderRadius: BorderRadius.circular(12),
              ),
             child: Center(
                child: isSvg
                    ? SvgPicture.asset(
                        iconPath,
                        height: 27,
                        width: 27,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      )
                    : Image.asset(
                        iconPath,
                        height: 27,
                        width: 27,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0XFF101828),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFFA3A3A3),
            ),
          ],
        ),
      ),
    );
  }
}