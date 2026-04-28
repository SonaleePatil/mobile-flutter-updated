import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/communities_awareness.dart';
import 'package:adcc/features/communities/sections/community_categories_grid.dart';
import 'package:adcc/features/communities/sections/community_horizontal_card.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:adcc/features/communities/view/view_all_communities_screen.dart';
import 'package:adcc/features/communities/view/view_all_communities_type.dart';
import 'package:adcc/features/communities/view/view_all_purpose_based.dart';
import 'package:adcc/features/communities/services/communities_service.dart';
import 'package:adcc/shared/widgets/community_header.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  int selectedFilterIndex = 0;
  String searchQuery = '';

  bool _isLoading = true;
  String? _errorMessage;

  final CommunitiesService _communitiesService = CommunitiesService();

  List<CommunityModel> _cityCommunities = [];
  List<CommunityModel> _groupCommunities = [];
  List<CommunityModel> _awarenessCommunities = [];

  List<CommunityModel> _allCommunities = [];

  final List<String> filterPills = const [
    'All',
    'Abu Dhabi',
    'Al Ain',
    'Western Region',
  ];

  @override
  void initState() {
    super.initState();
    _loadAllSections();
  }

  Future<void> _loadAllSections() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _communitiesService.getCityCommunities(),
        _communitiesService.getGroupCommunities(),
        _communitiesService.getAwarenessCommunities(),
      ]);

      if (!mounted) return;

      List<CommunityModel> parse(dynamic resData) {
        final raw = resData;

        List<dynamic> communitiesList = [];

        if (raw is Map<String, dynamic>) {
          if (raw['data'] is Map &&
              (raw['data'] as Map).containsKey('communities') &&
              (raw['data'] as Map)['communities'] is List) {
            communitiesList = (raw['data'] as Map)['communities'] as List;
          } else if (raw['communities'] is List) {
            communitiesList = raw['communities'] as List;
          }
        } else if (raw is List) {
          communitiesList = raw;
        }

        return communitiesList
            .whereType<Map<String, dynamic>>()
            .map((e) => CommunityModel.fromJson(e))
            .toList();
      }

      final cityRes = results[0];
      final groupRes = results[1];
      final awarenessRes = results[2];

      if (!cityRes.success || !groupRes.success || !awarenessRes.success) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load communities";
        });
        return;
      }

      final cityList = parse(cityRes.data);
      final groupList = parse(groupRes.data);
      final awarenessList = parse(awarenessRes.data);

      setState(() {
        _isLoading = false;

        _cityCommunities = cityList;
        _groupCommunities = groupList;
        _awarenessCommunities = awarenessList;

        _allCommunities = [
          ...cityList,
          ...groupList,
          ...awarenessList,
        ];

        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = "Unexpected error: $e";
      });
    }
  }

  List<String> get _backendTypes {
    final set = <String>{};

    for (final c in _allCommunities) {
      final t = c.type.trim();
      if (t.isNotEmpty) set.add(t);
    }

    final list = set.toList();
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  List<CommunityModel> _applySearch(List<CommunityModel> input) {
    if (searchQuery.trim().isEmpty) return input;

    final q = searchQuery.trim().toLowerCase();

    return input.where((c) {
      return c.title.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.category.any((cat) => cat.toLowerCase().contains(q)) ||
          c.type.toLowerCase().contains(q) ||
          (c.location ?? '').toLowerCase().contains(q) ||
          (c.trackName ?? '').toLowerCase().contains(q) ||
          (c.terrain ?? '').toLowerCase().contains(q) ||
          (c.distance?.toString() ?? '').contains(q);
    }).toList();
  }

  List<CommunityModel> _applyCityPills(List<CommunityModel> input) {
    if (selectedFilterIndex == 0) return input;

    final selected = filterPills[selectedFilterIndex].toLowerCase();

    return input.where((c) {
      return (c.location ?? '').toLowerCase().contains(selected);
    }).toList();
  }

  List<CommunityModel> get _filteredCityCommunities =>
      _applySearch(_applyCityPills(_cityCommunities));

  List<CommunityModel> get _filteredGroupCommunities =>
      _applySearch(_groupCommunities);

  List<CommunityModel> get _filteredAwarenessCommunities =>
      _applySearch(_awarenessCommunities);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: _isLoading
            ? const _CommunitiesLoadingUI()
            : (_errorMessage != null
                ? _CommunitiesErrorUI(
                    message: _errorMessage!,
                    onRetry: _loadAllSections,
                  )
                : _buildMainUI(context)),
      ),
    );
  }

  Widget _buildMainUI(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
   

      CommunityHeader(
  imagePath: 'assets/images/cycling_1.png',
  title: 'Communities',
  wantSearchBar: true,
  showBackButton: true,
  searchValue: searchQuery,
  onChangeHandler: (value) {
    setState(() => searchQuery = value);
  },
  placeholder: 'Search by track name, city, distance or terrain...',
),


        const SizedBox(height: 37),

        // CITY
        SectionHeader(
          title: 'Communities in Your City',
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllCommunitiesScreen(
                  title: 'Communities in Your City',
                  communities: _filteredCityCommunities,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 27),
        CommunitiesAwareness(
          communities: _filteredCityCommunities,
        ),

        const SizedBox(height: 50),

        // TYPES
        SectionHeader(
          title: 'Browse by Community Type',
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommunityTypeScreen(
                  title: "Community Types",
                  communities: _applySearch(_allCommunities),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 34),

        CommunityCategoriesGrid(
          types: _backendTypes,
          onCategoryTap: (type) async {
            final res = await _communitiesService.getCommunitiesByType(type);

            if (!res.success || res.data == null) return;

            List<CommunityModel> list = [];
            final raw = res.data;

            if (raw is Map<String, dynamic> &&
                raw['data'] is Map &&
                (raw['data'] as Map)['communities'] is List) {
              list = ((raw['data'] as Map)['communities'] as List)
                  .whereType<Map<String, dynamic>>()
                  .map((e) => CommunityModel.fromJson(e))
                  .toList();
            }

            if (!context.mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllCommunitiesScreen(
                  title: type,
                  communities: list,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 74),

        // PURPOSE BASED
        SectionHeader(
          title: 'Purpose-Based Communities',
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllPurposeCommunitiesScreen(
                  title: "Purpose-Based Communities",
                  communities: _filteredGroupCommunities,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 25),
        _buildGroupCommunitiesSection(),
        const SizedBox(height: 105),
      ],
    );
  }

  Widget _buildGroupCommunitiesSection() {
    final groupCommunities = _filteredGroupCommunities;

    if (groupCommunities.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'No community groups found',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: groupCommunities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final community = groupCommunities[index];

          return CommunityHorizontalCard(
            title: community.title,
            description: community.description,
            imagePath: community.imageUrl ?? 'assets/images/cycling_1.png',
       onExplore: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CommunityCityDetails(community: community),
    ),
  );
},

          );
        },
      ),
    );
  }
}

class _CommunitiesLoadingUI extends StatelessWidget {
  const _CommunitiesLoadingUI();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        const SizedBox(height: 16),

        // Banner placeholder
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        const SizedBox(height: 24),

        // Section title placeholder
        Container(
          height: 18,
          width: 220,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 16),

        // Big card placeholder
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        const SizedBox(height: 24),

        // Another section
        Container(
          height: 18,
          width: 260,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        const SizedBox(height: 24),

        Container(
          height: 18,
          width: 240,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Container(
                width: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F4),
                  borderRadius: BorderRadius.circular(18),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CommunitiesErrorUI extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CommunitiesErrorUI({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 44, color: Colors.redAccent),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenOchre,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Retry",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
