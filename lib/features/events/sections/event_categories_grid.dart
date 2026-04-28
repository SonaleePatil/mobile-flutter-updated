import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';

/// Model for event category
class EventCategory {
  final String title;
  final String imagePath;

  const EventCategory({
    required this.title,
    required this.imagePath,
  });
}

/// Grid widget displaying event categories
class EventCategoriesGrid extends StatelessWidget {
  final Function(String category)? onCategoryTap;

  const EventCategoriesGrid({
    super.key,
    this.onCategoryTap,
  });

  // List of event categories matching the design
  static final List<EventCategory> categories = [
    const EventCategory(
      title: 'Races',
      imagePath: 'assets/icons/ra.png',
    ),
    const EventCategory(
      title: 'Community Rides',
      imagePath: 'assets/icons/cf.png',
    ),
    const EventCategory(
      title: 'Training & Clinics',
      imagePath: 'assets/icons/tc.png',
    ),
    const EventCategory(
      title: 'Awareness Rides',
      imagePath: 'assets/icons/ra.png',
    ),
    const EventCategory(
      title: 'Family & Kids',
      imagePath: 'assets/icons/cf.png',
    ),
    const EventCategory(
      title: 'Corporate',
      imagePath: 'assets/icons/tc.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryCard(
          category: category,
          onTap: () {
            onCategoryTap?.call(category.title);
          },
        );
      },
    );
  }
}

/// Individual category card widget
class _CategoryCard extends StatelessWidget {
  final EventCategory category;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardLightBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title at the top
              Text(
                category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Image illustration - takes most of the space
              Expanded(
                child: Center(
                  child: AdaptiveImage(
                    imagePath: category.imagePath,
                    fit: BoxFit.contain,
                    placeholderColor: AppColors.softCream,
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
