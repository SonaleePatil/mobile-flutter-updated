import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/adaptive_image.dart';

class ListingsScreen extends StatelessWidget {
  final String? imagePath;

  const ListingsScreen({super.key, this.imagePath});

  Widget _listingCard(BuildContext context) {
    return SizedBox(
      width: 357,
      height: 268,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.44764),
              child: AdaptiveImage(
                imagePath: imagePath ?? 'assets/images/cycling_1.png',
                width: 357,
                height: 220,
                fit: BoxFit.cover,
                placeholderColor: AppColors.charcoal.withOpacity(0.06),
              ),
            ),
          ),

          Positioned(
            top: 12,
            left: 7,
            child: Container(
              width: 62,
              height: 21,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(22.5),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 12,
                    color: Colors.white,
                  ),
                  SizedBox(width: 3),
                  Text(
                    'Sharjah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 9.75,
                      fontWeight: FontWeight.w500,
                      height: 13 / 9.75,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Positioned(
            left: 0,
            top: 230,
            child: Text(
              'Trek Domane',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 21 / 14,
                color: Color(0xFF1A1C20),
              ),
            ),
          ),

          Positioned(
            left: 0,
            top: 254,
            child: Text(
              'Posted by Mahmoud shaalan',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 14 / 11,
                color: const Color(0xFF1A1C20).withOpacity(0.5),
              ),
            ),
          ),

          Positioned(
            left: 157,
            top: 255,
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6B7280),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '2 days ago',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 11 / 10,
                    color: const Color(0xFF1A1C20).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          const Positioned(
            right: 0,
            top: 239,
            child: Text(
              '7500 AED',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                color: Color(0xFFF9660E),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          color: const Color.fromRGBO(249, 102, 14, 0.36),
          borderRadius: BorderRadius.circular(53.8462),
        ),
        child: const Icon(
          Icons.arrow_back,
          size: 13,
          color: Color(0xFFF9660E),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 36),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    children: [
                      _backButton(context),
                      const Spacer(),
                      const Text(
                        'My Listings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 28 / 22,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 35),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                TabBar(
                  indicatorColor: const Color(0xFFF9660E),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.black.withOpacity(0.5),
                  dividerHeight: 3,
                  labelColor: const Color(0xFFF9660E),
                  unselectedLabelColor: Colors.black.withOpacity(0.5),
                  labelStyle: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 20 / 16,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 20 / 16,
                  ),
                  tabs: const [
                    Tab(text: 'Active listings'),
                    Tab(text: 'Sold items'),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 36, 16, 0),
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: 1,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) =>
                              _listingCard(context),
                        ),
                      ),

                      Center(
                        child: Text(
                          'No sold items yet',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            color: AppColors.textDark.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
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