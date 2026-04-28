import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AvailableRewardsSection extends StatelessWidget {
  const AvailableRewardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "Available Rewards",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 16),

        RewardItemCard(
          title: "20% Off Bike Shop",
          subtitle: "Complete 100 km in a single ride",
          points: "500 Pts",
        ),
        RewardItemCard(
          title: "Free Coffee",
          subtitle: "Café Rider",
          points: "150 Pts",
        ),
        RewardItemCard(
          title: "Premium Cycling",
          subtitle: "ADCC Store",
          points: "1000 Pts",
        ),
        RewardItemCard(
          title: "Energy Gel Pack (10x)",
          subtitle: "Nutrition Zone",
          points: "300 Pts",
        ),
        RewardItemCard(
          title: "Bike Maintenance Service",
          subtitle: "Pro Bike Service",
          points: "800 Pts",
        ),

        SizedBox(height: 40),
      ],
    );
  }
}


class RewardItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String points;

  const RewardItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2, bottom: 12),
      child: Container(
        width: 358,
        height: 102,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E2),
          borderRadius: BorderRadius.circular(9.9496),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [

           
            Padding(
              padding: const EdgeInsets.only(top: 15), 
              child: Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.only(
                  top: 10,
                  right: 11.4545,
                  bottom: 9.4595,
                  left: 10.9091,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0DDAF),
                  borderRadius: BorderRadius.circular(53.8462),
                ),
              child: Image.asset(
  "assets/icons/medal.png",
  width: 40,
  height: 40,
  fit: BoxFit.cover,
),
              ),
            ),

            const SizedBox(width: 14),

       
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 14), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                   Text(
  title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: 0,
    color: AppColors.charcoal
  ),
),

                    const SizedBox(height: 6),

                   Text(
  subtitle,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

                    const SizedBox(height: 7),

                    /// POINT BADGE
                    Container(
                      width: 59,
                      height: 22,
                      padding: const EdgeInsets.only(
                        top: 3,
                        right: 8,
                        bottom: 4,
                        left: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        points,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

   
            Padding(
              padding: const EdgeInsets.only(top: 36), 
              child: Container(
                width: 94,
                height: 30,
                padding: const EdgeInsets.only(
                  top: 6,
                  right: 10,
                  bottom: 6,
                  left: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFC12D32),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFC12D32),
                    width: 1.2365,
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
  "Claim now",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: 'Outfit',
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: 0,
  ),
)
              ),
            ),
          ],
        ),
      ),
    );
  }
}