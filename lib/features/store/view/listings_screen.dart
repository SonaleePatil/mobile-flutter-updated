import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/adaptive_image.dart';

class ListingsScreen extends StatelessWidget {
  final String? imagePath;

  const ListingsScreen({super.key, this.imagePath});

  Widget _listingCard(BuildContext context) {
    return Container(
      width: 357,
      height: 268,
      decoration: BoxDecoration(
        color: AppColors.softCream,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoal.withValues(alpha: 0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: AdaptiveImage(
                  imagePath: imagePath ?? 'assets/images/cycling_1.png',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  placeholderColor:
                      AppColors.charcoal.withValues(alpha: 0.06),
                ),
              ),

              /// LOCATION BADGE
              Positioned(
                top: 12,
                left: 7,
                child: Container(
                  width: 62,
                  height: 21,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: const Color(0x33FFFFFF),
                    borderRadius: BorderRadius.circular(22.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.white,
                      ),
                      SizedBox(width: 3),
                     Text(
  "Sharjah",
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Satoshi",
    fontSize: 9.75,
    fontWeight: FontWeight.w500,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: Colors.white,
  ),
)
                    ],
                  ),
                ),
              )
            ],
          ),

          /// DETAILS
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                     Text(
  "Trek Domane",
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5, // 150% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
                      SizedBox(height: 3),
                     Text(
  "Posted by Mahmoud shaalan • 2 days ago",
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark.withValues(alpha: 0.5),
  ),
),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              Text(
  "7500 AED",
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5, 
    letterSpacing: 0,
    color: AppColors.deepRed,
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// BACK BUTTON
  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 35,
        height: 35,
        padding: const EdgeInsets.only(
          top: 10,
          right: 7.5,
          bottom: 9.5,
          left: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0x5CC12D32),
          borderRadius: BorderRadius.circular(53.8462),
        ),
        child: const Icon(
          Icons.arrow_back,
          size: 13,
          color: Color(0xFFC12D32),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.softCream,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _backButton(context),
                      const Spacer(),
                      const Text(
                        "My Listings",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 35)
                    ],
                  ),
                ),
          
                const SizedBox(height: 20),
          
                /// TABS
                const TabBar(
  indicatorColor: const Color(0xFFC12D32),
  indicatorWeight: 2,
  indicatorSize: TabBarIndicatorSize.tab, // full tab width
  labelColor: const Color(0xFFC12D32),
  unselectedLabelColor: Colors.black54,
  labelStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: "Outfit",
  ),
  tabs: const [
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: const Text(
  "Active listings",
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0,
  ),
),
      ),
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
      child: const Text(
  "Sold items",
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.0, // 100% line height
    letterSpacing: 0,
  ),
),
      ),
    ),
  ],
),
          
                /// TAB VIEW
                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: ListView.separated(
                          itemCount: 1,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) =>
                              _listingCard(context),
                        ),
                      ),
          
                      /// SOLD ITEMS
                      Center(
                        child: Text(
                          "No sold items yet",
                          style: TextStyle(
                            color:
                                AppColors.textDark.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}