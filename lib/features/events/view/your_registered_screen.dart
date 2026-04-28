import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  final String eventTitle;
  final String eventLocationLine;
  final String date;
  final String location;
  final String type;
  final String community;

  final String eventImagePath;

  final String redArcImagePath;

  const RegistrationSuccessScreen({
    super.key,
    required this.eventTitle,
    required this.eventLocationLine,
    required this.date,
    required this.location,
    required this.type,
    required this.community,
    required this.eventImagePath,
    required this.redArcImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
  child: ListView(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
    children: [

      Stack(
  clipBehavior: Clip.none,
  children: [

          Positioned(
            left: -52,
            top: 240,
            child: Image.asset(
              redArcImagePath,
              width: 160,
              fit: BoxFit.contain,
            ),
          ),

          Column(
            children: [
            
                Row(
                  children: [
                    _BackCircleButton(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 28),

              Center(
  child: ClipOval(
    child: Image.asset(
      "assets/icons/checkmark.gif",
      height: 102,
      width: 102,
      fit: BoxFit.cover,
    ),
  ),
),

                const SizedBox(height: 18),

                Center(
                  child: Text(
                    "You're registered!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "Get ready for an amazing ride with\nthe community!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w400,
                      color: AppColors.charcoal,
                    ),
                  ),
                ),

                const SizedBox(height: 59),

                _EventSummaryCard(
                  eventImagePath: eventImagePath,
                  title: eventTitle,
                  subtitle: eventLocationLine,
                  date: date,
                  location: location,
                  type: type,
                  community: community,
                ),

                const SizedBox(height: 35),

              _ActionTile(
  imagePath: "assets/icons/add_calendar.png",
  title: "Add to Calendar",
  onTap: () {},
),
                const SizedBox(height: 12),
               _ActionTile(
  imagePath: "assets/icons/share_2.png",
  title: "Share with Friends",
  onTap: () {},
),
                const SizedBox(height: 12),
             _ActionTile(
  imagePath: "assets/icons/add_calendar.png",
  title: "View My Events",
  onTap: () {},
),

                const SizedBox(height: 40),

                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                 onPressed: () {
  Navigator.of(context).popUntil((route) => route.isFirst);
},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Return to Home",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 61),
                        ],
          )
        ],
      ),

    ],
  ),
),
    );
  }
}

class _BackCircleButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackCircleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightDeepRed.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          height: 35,
          width: 35,
          child: Icon(
            Icons.arrow_back,
            size: 15,
            color: AppColors.deepRed,
          ),
        ),
      ),
    );
  }
}

class _EventSummaryCard extends StatelessWidget {
  final String eventImagePath;
  final String title;
  final String subtitle;

  final String date;
  final String location;
  final String type;
  final String community;

  const _EventSummaryCard({
    required this.eventImagePath,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.location,
    required this.type,
    required this.community,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightPeach,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  eventImagePath,
                  height: 87,
                  width: 95,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                        color: AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.2,
                        fontWeight: FontWeight.w400,
                        color: AppColors.charcoal.withValues(alpha: 0.55),
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
                child: _MiniInfoCard(
                  imagePath: "assets/icons/clock.png",
                  title: "When",
                 value: _formatDate(date),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniInfoCard(
                    imagePath: "assets/icons/distance.png",
                  title: "Location",
                  value: location,
                  
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MiniInfoCard(
                   imagePath: "assets/icons/red_star.png",
                  title: "Type",
                  value: type,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniInfoCard(
                imagePath: "assets/icons/red_people.png",
                  title: "Community",
                  value: community,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _MiniInfoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String value;

  const _MiniInfoCard({
    required this.imagePath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.dustyRose,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.lightBeige,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: 18,
            width: 18,
            color: AppColors.deepRed,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// title row
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.charcoal,
                  ),
                ),

                const SizedBox(height: 3),

                /// value
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.1,
                    fontWeight: FontWeight.w500,
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

class _ActionTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;

  const _ActionTile({
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFEFD7),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 13, 16, 13),
          child: Row(
            children: [

              /// icon container
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFCF9F0C),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 27,
                    height: 27,
                    color: iconColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              /// title
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

            
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDate(String rawDate) {
  try {
    final parsed = DateTime.parse(rawDate);
    return DateFormat("dd MMM yyyy").format(parsed);
  } catch (e) {
    return rawDate; // fallback
  }
}