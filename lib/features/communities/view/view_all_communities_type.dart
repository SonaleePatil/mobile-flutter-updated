import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/community_list_card.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:adcc/shared/widgets/category_selector.dart';
import 'package:flutter/material.dart';

class CommunityTypeScreen extends StatefulWidget {
  final String title;
  final List<CommunityModel> communities;

  const CommunityTypeScreen({
    super.key,
    required this.title,
    required this.communities,
  });

  @override
  State<CommunityTypeScreen> createState() => _CommunityTypeScreenState();
}

class _CommunityTypeScreenState extends State<CommunityTypeScreen> {
  int selectedFilterIndex = 0;

  final List<String> filters = const [
    "Racing & Performance",
    "Elite Community",
    "Family Rides",
    "Women",
  ];

  List<CommunityModel> get filteredCommunities {
    final all = widget.communities;
    if (all.isEmpty) return [];

    final selected = filters[selectedFilterIndex].toLowerCase().trim();

    bool matches(CommunityModel c) {
      final type = c.type.toLowerCase();
      final title = c.title.toLowerCase();
      final categories = c.category.map((e) => e.toLowerCase()).toList();

      bool containsAny(String value, List<String> keys) {
        for (final k in keys) {
          if (value.contains(k)) return true;
        }
        return false;
      }

      bool categoryContainsAny(List<String> keys) {
        for (final cat in categories) {
          if (containsAny(cat, keys)) return true;
        }
        return false;
      }

      // Racing & Performance
      if (selected.contains("racing")) {
        return containsAny(type, ["racing", "performance"]) ||
            containsAny(title, ["racing", "performance"]) ||
            categoryContainsAny(["racing", "performance"]);
      }

      // Family
      if (selected.contains("family")) {
        return containsAny(type, ["family"]) ||
            containsAny(title, ["family"]) ||
            categoryContainsAny(["family"]);
      }

      // Women
      if (selected.contains("women")) {
        return containsAny(type, ["women", "ladies"]) ||
            containsAny(title, ["women", "ladies"]) ||
            categoryContainsAny(["women", "ladies"]);
      }

      return true;
    }

    final filtered = all.where(matches).toList();

    if (filtered.isEmpty) {
      return all.take(6).toList();
    }

    return filtered.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredCommunities;

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            BannerHeadder(
              imagePath: 'assets/images/cycling_1.png',
              title: widget.title,
              subtitle: 'Choose communities based on your riding preference',
              onBackTap: () => Navigator.pop(context),
            ),

            const SizedBox(height: 16),

            /// Filter Pills
            CategorySelector(
              categories: filters,
              selectedIndex: selectedFilterIndex,
              onSelected: (index) {
                setState(() => selectedFilterIndex = index);
              },
            ),

            const SizedBox(height: 35),

            Text(
              '${list.length} communities found',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 25),

            ...List.generate(list.length, (index) {
              final c = list[index];

              return Padding(
                padding: EdgeInsets.only(bottom: index == list.length - 1 ? 0 : 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommunityCityDetails(community: c),
                      ),
                    );
                  },
                 child: CommunityListCard(
  community: c,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommunityCityDetails(community: c),
      ),
    );
  },
),

                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
