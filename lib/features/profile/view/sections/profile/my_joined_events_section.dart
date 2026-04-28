import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


class MyJoinedEventsSection extends StatelessWidget {
  const MyJoinedEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.softCream,
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
  "Joined Events",
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1, 
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

          const SizedBox(height: 16),

          /// -------- CARD LIST --------
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return const _EventCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310,
      height: 230,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [

            /// -------- IMAGE --------
            Positioned.fill(
              child: Image.asset(
                "assets/images/cycling_1.png",
                fit: BoxFit.cover,
              ),
            ),

     
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.12),
              ),
            ),

            /// Featured chip
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.deepRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
  "Featured",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: 'Geist',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12, // ≈1.33
    letterSpacing: 0,
    color: Color(0xFFFFF4E3),
  ),
)
              ),
            ),

           /// Share button
Positioned(
  top: 17,
  right: 17,
  child: Container(
    width: 25,
    height: 25,
    decoration: const BoxDecoration(
      color: Color(0xFFC12D32),
      shape: BoxShape.circle,
    ),
    child: const Center(
      child: Icon(
        Icons.share,
        size: 16,
        color: Colors.white,
      ),
    ),
  ),
),

            /// Bottom Info Card
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// Registered chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3EE606).withOpacity(0.30),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
  "Registered",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 9.9381,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Color(0xFF328700),
  ),
)
                    ),

                    const SizedBox(height: 6),

                    const Text(
  "Bike Abu Dhabi Gran Fondo 2025",
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.15,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

                    const SizedBox(height: 8),

                  Row(
  children: const [
    _MetaItem(
      icon: ImageIcon(
        AssetImage("assets/icons/calender.png"),
        size: 14,
        color: Color(0XFF595959),
      ),
      text: "Every Sunday",
    ),
    SizedBox(width: 12),
    _MetaItem(
      icon: ImageIcon(
        AssetImage("assets/icons/water_statoins.png"),
        size: 14,
       color: Color(0XFF595959),
      ),
      text: "Abu Dhabi",
    ),
    SizedBox(width: 12),
    _MetaItem(
      icon: ImageIcon(
        AssetImage("assets/icons/km_fill.png"),
        size: 14,
        color: Color(0XFF595959),
      ),
      text: "150 km",
    ),
  ],
)
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
class _MetaItem extends StatelessWidget {
  final Widget icon;
  final String text;

  const _MetaItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          icon,
          const SizedBox(width: 6),
          Expanded(
            child:Text(
  text,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12.8226,
    fontWeight: FontWeight.w400,
    height: 17.0968 / 12.8226, // ≈1.33
    letterSpacing: 0,
    color: Color(0xFF484A4D),
  ),
)
          ),
        ],
      ),
    );
  }
}