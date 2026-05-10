import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';

class RecentlyPost extends StatelessWidget {
  final List<HomeStoreItemModel> items;
  final bool showFallback;

  const RecentlyPost({
    super.key,
    this.items = const [],
    this.showFallback = true,
  });

  @override
  Widget build(BuildContext context) {
    const fallbackItems = [
      HomeStoreItemModel(
        id: '',
        image: 'assets/images/bike.png',
        title: 'Trek Domane',
        postedBy: 'Mahmoud shaalan',
        price: '7500 AED',
      ),
    ];
    final data = items.isEmpty
        ? (showFallback ? fallbackItems : const <HomeStoreItemModel>[])
        : items;
    if (data.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// SECTION HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recently Posted",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  letterSpacing: 0,
                  color: AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Text(
                      "View All",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFF484A4D),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Color(0xFF484A4D),
                    )
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          /// CARD LIST
          SizedBox(
            height: 456,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: data
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: RecentlyPostCard(item: item),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class RecentlyPostCard extends StatelessWidget {
  final HomeStoreItemModel item;

  const RecentlyPostCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 314,
      height: 456,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF1F1FB),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE + SHARE BUTTON
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AdaptiveImage(
                  imagePath: item.image,
                  width: 290,
                  height: 351,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.share,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// TITLE
          Padding(
            padding: EdgeInsets.zero,
            child: Text(
              item.title,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.5,
                letterSpacing: 0,
                color: AppColors.textDark,
              ),
            ),
          ),

          const SizedBox(height: 1),

          /// POSTED BY
          Padding(
            padding: EdgeInsets.zero,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0,
                ),
                children: [
                  const TextSpan(
                    text: "Posted by ",
                    style: TextStyle(
                      color: Color(0x991A1C20),
                    ),
                  ),
                  TextSpan(
                    text: item.postedBy,
                    style: const TextStyle(
                      color: Color(0xFF1A1C20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          Padding(
            padding: EdgeInsets.zero,
            child: Text(
              item.price,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.5,
                letterSpacing: 0,
                color: AppColors.deepRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
