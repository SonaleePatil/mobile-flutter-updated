import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/profile/view/sections/Cycling%20Details/completed_rides_card.dart';
import 'package:adcc/features/profile/view/sections/Cycling%20Details/cycling_identity_card.dart';
import 'package:adcc/features/profile/view/sections/Cycling%20Details/gear_card.dart';
import 'package:adcc/features/profile/view/sections/Cycling%20Details/ride_tile.dart';
import 'package:adcc/features/profile/view/sections/badges/rider_level_section.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';

class CyclingDetailsScreen extends StatelessWidget {
  const CyclingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: Padding(
        padding:            const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
        
             BannerHeadder(
                      imagePath:
                          'assets/images/cycling_1.png',
                      title: 'My cycling details',
                      subtitle:
                          '',
                          centerTitle: true,
                      onBackTap: () =>
                          Navigator.pop(context),
                    ),
          
                const SizedBox(height: 28),
      const RiderStatsSection(
  riderLevel: "Rider Level: Intermediate",

  badgesTitle: "Total Distance",
  badgesValue: "1247 km",

  pointsTitle: "Ride Streak",
  pointsValue: "6 Days",

  progressTitle: "Badges Earned",
  progressValue: "12",
),
                const SizedBox(height: 18),
        
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 2),
  child: SizedBox(
    width: double.infinity,
    height: 51,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC12D32),
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.4843),
        ),
      ),
     child:  Text(
  "View Full Stats",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 17.4634,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: Colors.white,
  ),
),
    ),
  ),
),
        
                const SizedBox(height: 40),
        
           const CyclingIdentityCard(),
                const SizedBox(height: 40),
        
      SectionHeader(
        title: "Your Rides & Events",
        onViewAll: () {
          print("View All Clicked");
        },
      ),
      const SizedBox(height: 31),
        const RideTile(
  title: "UAE National Day Ride",
  distance: "25 km",
  riders: "25k riders",
  date: "Dec 2",
  imagePath:  'assets/images/cycling_1.png',
),

const RideTile(
  title: "UAE Amateur Stage Ride",
  distance: "25 km",
  riders: "25k riders",
  date: "Dec 2",
  imagePath:  'assets/images/cycling_1.png',
),

const RideTile(
  title: "UAE National Day Ride",
  distance: "25 km",
  riders: "25k riders",
  date: "Dec 2",
  imagePath:  'assets/images/cycling_1.png',
),
        
                const SizedBox(height: 40),
        const CompletedRidesCard(
  rides: 18,
),
                const SizedBox(height: 46),
        
                communitiesHeader(),
        
               Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8),
  child: Row(
    children: [
      communityChip("Abu Dhabi Riders"),
      const SizedBox(width: 20),
      communityChip("Long Distance Crew"),
    ],
  ),
),
                const SizedBox(height: 56),
        
            /// LISTED GEAR
Padding(
  padding: const EdgeInsets.symmetric( vertical: 10),
  child: Align(
   alignment: Alignment.centerLeft,
child: Text(
  "Your Listed Gear",
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
  ),
),
  const SizedBox(height: 18),
        SizedBox(
  height: 272,
  child: ListView(
    scrollDirection: Axis.horizontal,

    children: const [

      GearCard(
        imagePath: 'assets/images/cycling_1.png',
        title: "DMT KR0 Road Shoes",
        price: "1300 AED",
        time: "2 days ago",
        postedBy: "Mark McEvoy",
      ),

      GearCard(
        imagePath: 'assets/images/cycling_1.png',
        title: "DMT KR0 Road Shoes",
        price: "1300 AED",
        time: "2 days ago",
        postedBy: "Mark McEvoy",
      ),

      GearCard(
        imagePath:'assets/images/cycling_1.png',
        title: "DMT KR0 Road Shoes",
        price: "1300 AED",
        time: "2 days ago",
        postedBy: "Mark McEvoy",
      ),
    ],
  ),
),
        
                const SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}



Widget communitiesHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

   
        Row(
          children:  [
        Image.asset(
  "assets/icons/your_communities.jpg", 
  width: 20,
  height: 20,
  fit: BoxFit.contain,
),
            SizedBox(width: 8),

            Text(
              "Your Communities",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        /// RIGHT SIDE (EXPLORE)
        Row(
          children: const [
            Text(
              "Explore",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            SizedBox(width: 4),

            Icon(
              Icons.chevron_right,
              size: 18,
              color: Colors.black54,
            ),
          ],
        )
      ],
    ),
  );
}

Widget communityChip(String text) {
  return Container(
    width: 140,
    height: 38,
    alignment: Alignment.center,
    padding: const EdgeInsets.fromLTRB(2, 9, 2, 9),
    decoration: BoxDecoration(
      color: AppColors.warmSand,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        width: 1.1803,
        color: AppColors.warmSand,
      ),
    ),
   child: Text(
  text,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
  );
}
