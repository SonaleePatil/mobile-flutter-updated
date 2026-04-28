import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/community_list_card.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:adcc/shared/widgets/category_selector.dart';
import 'package:flutter/material.dart';

class ViewAllPurposeCommunitiesScreen extends StatefulWidget {
  final String title;
  final List<CommunityModel> communities;

  const ViewAllPurposeCommunitiesScreen({
    super.key,
    required this.title,
    required this.communities,
  });

  @override
  State<ViewAllPurposeCommunitiesScreen> createState() =>
      _ViewAllPurposeCommunitiesScreenState();
}

class _ViewAllPurposeCommunitiesScreenState
    extends State<ViewAllPurposeCommunitiesScreen> {
  int selectedIndex = 0;

  final List<String> filters = const [
    "All",
    "Awareness & Charity",
    "Corporate",
  ];


  List<CommunityModel> get filteredList {
    final all = widget.communities;
    if (all.isEmpty) return [];

    // All
    if (selectedIndex == 0) return all;

    final selected = filters[selectedIndex].toLowerCase().trim();

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

      // Awareness & Charity
      if (selected.contains("awareness")) {
        return containsAny(type, ["awareness", "charity"]) ||
            containsAny(title, ["awareness", "charity"]) ||
            categoryContainsAny(["awareness", "charity"]);
      }

      // Corporate
      if (selected.contains("corporate")) {
        return containsAny(type, ["corporate"]) ||
            containsAny(title, ["corporate"]) ||
            categoryContainsAny(["corporate"]);
      }

      return true;
    }

    final filtered = all.where(matches).toList();


    if (filtered.isEmpty) return all;

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredList;

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            /// Banner
            BannerHeadder(
              imagePath: "assets/images/cycling_1.png",
              title: widget.title,
              subtitle: "Communities based on purpose and goals",
              onBackTap: () => Navigator.pop(context),
            ),

            const SizedBox(height: 16),

            /// Category Selector
            CategorySelector(
              categories: filters,
              selectedIndex: selectedIndex,
              onSelected: (i) => setState(() => selectedIndex = i),
            ),

            const SizedBox(height: 18),

         GestureDetector(
  onTap: () {
    if (list.isEmpty) return;

    final first = list.first;

  
  },
  child: const Text(
    "Explore Communities",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: Colors.black,
    ),
  ),
),


            const SizedBox(height: 14),

       
            ...List.generate(list.length, (index) {
              final c = list[index];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == list.length - 1 ? 0 : 20,
                ),
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

              );
            }),
          ],
        ),
      ),
    );
  }
}
